import 'dart:convert';
import 'package:dio/dio.dart';

import '../../models/kazumi_rule.dart';
import '../../../core/parser/xpath_parser.dart';
import 'video_source.dart';

/// 基于规则的视频源
/// 
/// 使用 Kazumi 规则格式解析网页，提取视频地址
class RuleVideoSource implements VideoSource {
  final KazumiRule rule;
  late final Dio _dio;

  RuleVideoSource(this.rule) {
    _dio = Dio(BaseOptions(
      baseUrl: rule.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent': rule.userAgent ?? 
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Referer': rule.referer ?? rule.baseUrl,
      },
    ));
  }

  @override
  String get name => rule.name;

  @override
  String? get iconUrl => null;

  @override
  Future<VideoInfo?> resolve(String animeName, int episode) async {
    try {
      // 1. 搜索番剧
      final searchResults = await _search(animeName);
      if (searchResults.isEmpty) {
        throw VideoSourceException('未找到相关番剧: $animeName');
      }

      // 2. 获取第一个匹配结果的详情页链接
      final detailUrl = searchResults.first;

      // 3. 获取分集链接
      final episodeUrl = await _getEpisodeUrl(detailUrl, episode);
      if (episodeUrl == null) {
        throw VideoSourceException('未找到第$episode集');
      }

      // 4. 提取视频 URL
      final videoUrl = await _extractVideoUrl(episodeUrl);
      if (videoUrl == null) {
        throw VideoSourceException('无法获取视频地址');
      }

      return VideoInfo(
        url: videoUrl,
        title: '$animeName - 第$episode集',
        headers: {
          'Referer': rule.referer ?? rule.baseUrl,
          'User-Agent': rule.userAgent ?? 
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );
    } on VideoSourceException {
      rethrow;
    } catch (e) {
      throw VideoSourceException('解析失败: $e');
    }
  }

  /// 搜索番剧
  Future<List<String>> _search(String keyword) async {
    try {
      final searchUrl = rule.searchUrl.replaceAll(
        '@keyword',
        Uri.encodeComponent(keyword),
      );

      Response response;
      if (rule.usePost) {
        // POST 请求：从 URL 中提取路径和参数
        final uri = Uri.parse(searchUrl);
        response = await _dio.post(
          uri.path.isNotEmpty ? uri.path : '/',
          data: uri.queryParameters,
          options: Options(contentType: Headers.formUrlEncodedContentType),
        );
      } else {
        // GET 请求：始终使用带 Headers 的 _dio 实例
        if (searchUrl.startsWith('http')) {
          // 完整 URL：提取路径和查询参数
          final uri = Uri.parse(searchUrl);
          final path = uri.path.isNotEmpty ? uri.path : '/';
          final query = uri.query.isNotEmpty ? '?${uri.query}' : '';
          response = await _dio.get('$path$query');
        } else {
          response = await _dio.get(searchUrl);
        }
      }

      final parser = XpathParser(response.data.toString());

      // 获取搜索结果列表
      final results = parser.query(rule.searchList);
      if (results.isEmpty) return [];

      // 获取详情页链接
      final detailUrls = <String>[];
      for (final result in results) {
        // 在当前元素内查找链接
        final resultParser = XpathParser(result.outerHtml);
        
        // 尝试多种方式获取链接
        String? href;
        
        // 方式 1：使用规则中的 searchResult
        href = resultParser.attribute(rule.searchResult, 'href');
        
        // 方式 2：如果 searchResult 是相对路径，尝试在当前元素上查找
        if (href == null || href.isEmpty) {
          href = result.attributes['href'];
        }
        
        // 方式 3：查找第一个带 href 的 <a> 标签
        if (href == null || href.isEmpty) {
          final links = resultParser.query('//a[@href]');
          if (links.isNotEmpty) {
            href = links.first.attributes['href'];
          }
        }

        if (href != null && href.isNotEmpty) {
          // 处理相对路径
          if (href.startsWith('http')) {
            detailUrls.add(href);
          } else if (href.startsWith('/')) {
            detailUrls.add('${rule.baseUrl}$href');
          } else {
            detailUrls.add('${rule.baseUrl}/$href');
          }
        }
      }

      return detailUrls;
    } catch (e) {
      if (e is VideoSourceException) rethrow;
      throw VideoSourceException('搜索失败: $e');
    }
  }

  /// 获取分集链接
  Future<String?> _getEpisodeUrl(String detailUrl, int episode) async {
    try {
      final response = await _dio.get(detailUrl);
      final parser = XpathParser(response.data.toString());

      // 获取分集列表容器
      final chapterContainers = parser.query(rule.chapterRoads);
      if (chapterContainers.isEmpty) return null;

      // 获取分集链接
      final chapterParser = XpathParser(chapterContainers.first.outerHtml);
      final episodeLinks = chapterParser.query(rule.chapterResult);

      if (episodeLinks.isEmpty) return null;

      // 集数从 1 开始，索引从 0 开始
      final index = episode - 1;
      if (index < 0 || index >= episodeLinks.length) return null;

      final href = episodeLinks[index].attributes['href'];
      if (href == null || href.isEmpty) return null;

      // 处理相对路径
      if (href.startsWith('http')) {
        return href;
      } else if (href.startsWith('/')) {
        return '${rule.baseUrl}$href';
      } else {
        return '${rule.baseUrl}/$href';
      }
    } catch (e) {
      return null;
    }
  }

  /// 从播放页面提取视频 URL
  Future<String?> _extractVideoUrl(String playPageUrl) async {
    try {
      final response = await _dio.get(playPageUrl);
      final html = response.data.toString();

      // 先用简单的字符串搜索查找常见模式
      // 模式1: var now="..." 或 var now='...'
      var idx = html.indexOf('var now=');
      if (idx >= 0) {
        var rest = html.substring(idx + 8);
        var quote = rest[0];
        if (quote == '"' || quote == "'") {
          var end = rest.indexOf(quote, 1);
          if (end > 0) {
            var url = rest.substring(1, end);
            if (url.startsWith('http')) {
              return await _followRedirects(url);
            }
          }
        }
      }

      // 模式2: var url="..." 或 var url='...'
      idx = html.indexOf('var url=');
      if (idx >= 0) {
        var rest = html.substring(idx + 7);
        var quote = rest[0];
        if (quote == '"' || quote == "'") {
          var end = rest.indexOf(quote, 1);
          if (end > 0) {
            var url = rest.substring(1, end);
            if (url.startsWith('http')) {
              return await _followRedirects(url);
            }
          }
        }
      }

      // 模式3: 查找 .m3u8 链接
      idx = html.indexOf('.m3u8');
      while (idx >= 0) {
        // 向前查找 http
        var start = html.lastIndexOf('http', idx);
        if (start >= 0) {
          var end = html.indexOf('"', idx);
          if (end < 0) end = html.indexOf("'", idx);
          if (end < 0) end = idx + 10;
          var url = html.substring(start, end);
          if (url.startsWith('http')) {
            return await _followRedirects(url);
          }
        }
        idx = html.indexOf('.m3u8', idx + 1);
      }

      // 模式4: 查找 .mp4 链接
      idx = html.indexOf('.mp4');
      while (idx >= 0) {
        var start = html.lastIndexOf('http', idx);
        if (start >= 0) {
          var end = html.indexOf('"', idx);
          if (end < 0) end = html.indexOf("'", idx);
          if (end < 0) end = idx + 5;
          var url = html.substring(start, end);
          if (url.startsWith('http')) {
            return await _followRedirects(url);
          }
        }
        idx = html.indexOf('.mp4', idx + 1);
      }

      // 模式5: "url":"..." 或 'url':'...'
      var urlPatterns = ['"url":"', "'url':'", '"url": "', "'url': '"];
      for (final pat in urlPatterns) {
        idx = html.indexOf(pat);
        if (idx >= 0) {
          var start = idx + pat.length;
          var quote = start > 0 ? html[start - 1] : '"';
          var end = html.indexOf(quote, start);
          if (end > start) {
            var url = html.substring(start, end);
            if (url.startsWith('http')) {
              return await _followRedirects(url);
            }
          }
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// 跟踪重定向获取真实地址
  Future<String> _followRedirects(String url, {int maxRedirects = 5}) async {
    String currentUrl = url;

    for (int i = 0; i < maxRedirects; i++) {
      try {
        final response = await Dio().get(
          currentUrl,
          options: Options(
            followRedirects: false,
            validateStatus: (status) => status != null && status >= 200 && status < 400,
          ),
        );

        final location = response.headers.value('location');
        if (location == null) break;

        // 处理相对路径
        if (location.startsWith('http')) {
          currentUrl = location;
        } else {
          currentUrl = Uri.parse(currentUrl).resolve(location).toString();
        }
      } catch (e) {
        break;
      }
    }

    return currentUrl;
  }
}
