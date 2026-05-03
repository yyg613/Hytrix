import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;

import 'video_source.dart';

/// 樱花动漫视频源
class YinghuaVideoSource implements VideoSource {
  static const String _baseUrl = 'https://www.yinghuaanime.com';
  static const String _userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

  late final Dio _dio;

  YinghuaVideoSource() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'User-Agent': _userAgent,
        'Referer': _baseUrl,
      },
    ));
  }

  @override
  String get name => '樱花动漫';

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
          'Referer': _baseUrl,
          'User-Agent': _userAgent,
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
      final response = await _dio.get(
        '/search.php',
        queryParameters: {'searchword': keyword},
      );

      final document = html_parser.parse(response.data);

      // 尝试多种选择器
      final selectors = [
        '.stui-vodlist__media li .detail h3.title a',
        '.stui-vodlist__media li h3.title a',
        '.searchlist li a',
        '.lpic li h2 a',
      ];

      for (final selector in selectors) {
        final results = document.querySelectorAll(selector);
        if (results.isNotEmpty) {
          return results
              .map((e) => e.attributes['href'])
              .where((href) => href != null && href.startsWith('/dm/'))
              .cast<String>()
              .toList();
        }
      }

      return [];
    } catch (e) {
      if (e is VideoSourceException) rethrow;
      throw VideoSourceException('搜索失败: $e');
    }
  }

  /// 获取分集链接
  Future<String?> _getEpisodeUrl(String detailUrl, int episode) async {
    try {
      final response = await _dio.get(detailUrl);
      final document = html_parser.parse(response.data);

      // 尝试多种选择器
      final selectors = [
        '.stui-content__playlist li a',
        '.playlist li a',
        '.stui-pannel_bd ul li a',
      ];

      List<dynamic> episodeLinks = [];
      for (final selector in selectors) {
        episodeLinks = document.querySelectorAll(selector);
        if (episodeLinks.isNotEmpty) break;
      }

      if (episodeLinks.isEmpty) return null;

      // 集数从 1 开始，索引从 0 开始
      final index = episode - 1;
      if (index < 0 || index >= episodeLinks.length) return null;

      final href = episodeLinks[index].attributes['href'];
      if (href == null) return null;

      // 如果是完整 URL，直接返回；否则拼接 baseUrl
      if (href.startsWith('http')) return href;
      return '$_baseUrl$href';
    } catch (e) {
      return null;
    }
  }

  /// 从播放页面提取视频 URL
  Future<String?> _extractVideoUrl(String playPageUrl) async {
    try {
      final response = await _dio.get(playPageUrl);
      final html = response.data.toString();

      // 尝试多种正则模式提取视频 URL
      final patterns = [
        RegExp(r'var\s+now\s*=\s*"([^"]+)"'),
        RegExp(r"var\s+now\s*=\s*'([^']+)'"),
        RegExp(r'var\s+url\s*=\s*"([^"]+)"'),
        RegExp(r"var\s+url\s*=\s*'([^']+)'"),
        RegExp(r'var\s+video\s*=\s*"([^"]+)"'),
        RegExp(r'"url"\s*:\s*"([^"]+)"'),
        RegExp(r'src\s*:\s*"([^"]+\.m3u8[^"]*)"'),
        RegExp(r'src\s*:\s*"([^"]+\.mp4[^"]*)"'),
      ];

      for (final pattern in patterns) {
        final match = pattern.firstMatch(html);
        if (match != null) {
          final url = match.group(1);
          if (url != null && url.isNotEmpty) {
            // 跟踪重定向获取真实地址
            return await _followRedirects(url);
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
        final response = await _dio.get(
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

/// 视频源异常
class VideoSourceException implements Exception {
  final String message;
  VideoSourceException(this.message);

  @override
  String toString() => message;
}
