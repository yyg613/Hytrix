import 'dart:convert';

/// Kazumi 规则模型
/// 
/// 规则格式（9行文本）：
/// 1. 规则名称
/// 2. 版本号
/// 3. 网站基础 URL
/// 4. 搜索 URL（@keyword 为占位符）
/// 5. 搜索结果列表的 Xpath
/// 6. 番剧名称的 Xpath
/// 7. 详情页/播放页链接的 Xpath
/// 8. 分集列表容器的 Xpath
/// 9. 分集链接的 Xpath
class KazumiRule {
  final String name;           // 规则名称
  final String version;        // 版本号
  final String baseUrl;        // 网站基础 URL
  final String searchUrl;      // 搜索 URL（@keyword 为占位符）
  final String searchList;     // 搜索结果列表的 Xpath
  final String searchName;     // 番剧名称的 Xpath
  final String searchResult;   // 详情页链接的 Xpath
  final String chapterRoads;   // 分集列表容器的 Xpath
  final String chapterResult;  // 分集链接的 Xpath
  
  // 可选字段
  final String? userAgent;     // 自定义 User-Agent
  final String? referer;       // 自定义 Referer
  final bool usePost;          // 是否使用 POST 请求
  final bool useWebview;       // 是否使用 WebView 嗅探
  final bool simplified;       // 是否使用简易解析

  const KazumiRule({
    required this.name,
    required this.version,
    required this.baseUrl,
    required this.searchUrl,
    required this.searchList,
    required this.searchName,
    required this.searchResult,
    required this.chapterRoads,
    required this.chapterResult,
    this.userAgent,
    this.referer,
    this.usePost = false,
    this.useWebview = true,
    this.simplified = false,
  });

  /// 从文本解析规则
  factory KazumiRule.fromText(String text) {
    final lines = text.split('\n').map((l) => l.trim()).toList();
    if (lines.length < 9) {
      throw const FormatException('规则格式错误：至少需要9行内容');
    }

    return KazumiRule(
      name: lines[0],
      version: lines[1],
      baseUrl: lines[2],
      searchUrl: lines[3],
      searchList: lines[4],
      searchName: lines[5],
      searchResult: lines[6],
      chapterRoads: lines[7],
      chapterResult: lines[8],
      userAgent: lines.length > 9 && lines[9].isNotEmpty ? lines[9] : null,
      referer: lines.length > 10 && lines[10].isNotEmpty ? lines[10] : null,
      usePost: lines.length > 11 && lines[11] == 'true',
      useWebview: lines.length > 12 ? lines[12] != 'false' : true,
      simplified: lines.length > 13 && lines[13] == 'true',
    );
  }

  /// 从 JSON 解析规则
  factory KazumiRule.fromJson(Map<String, dynamic> json) {
    return KazumiRule(
      name: json['name'] as String,
      version: json['version'] as String,
      baseUrl: json['baseUrl'] as String,
      searchUrl: json['searchUrl'] as String,
      searchList: json['searchList'] as String,
      searchName: json['searchName'] as String,
      searchResult: json['searchResult'] as String,
      chapterRoads: json['chapterRoads'] as String,
      chapterResult: json['chapterResult'] as String,
      userAgent: json['userAgent'] as String?,
      referer: json['referer'] as String?,
      usePost: json['usePost'] as bool? ?? false,
      useWebview: json['useWebview'] as bool? ?? true,
      simplified: json['simplified'] as bool? ?? false,
    );
  }

  /// 转换为文本格式
  String toText() {
    return [
      name,
      version,
      baseUrl,
      searchUrl,
      searchList,
      searchName,
      searchResult,
      chapterRoads,
      chapterResult,
      userAgent ?? '',
      referer ?? '',
      usePost.toString(),
      useWebview.toString(),
      simplified.toString(),
    ].join('\n');
  }

  /// 转换为 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
      'baseUrl': baseUrl,
      'searchUrl': searchUrl,
      'searchList': searchList,
      'searchName': searchName,
      'searchResult': searchResult,
      'chapterRoads': chapterRoads,
      'chapterResult': chapterResult,
      if (userAgent != null) 'userAgent': userAgent,
      if (referer != null) 'referer': referer,
      'usePost': usePost,
      'useWebview': useWebview,
      'simplified': simplified,
    };
  }

  /// 复制规则
  KazumiRule copyWith({
    String? name,
    String? version,
    String? baseUrl,
    String? searchUrl,
    String? searchList,
    String? searchName,
    String? searchResult,
    String? chapterRoads,
    String? chapterResult,
    String? userAgent,
    String? referer,
    bool? usePost,
    bool? useWebview,
    bool? simplified,
  }) {
    return KazumiRule(
      name: name ?? this.name,
      version: version ?? this.version,
      baseUrl: baseUrl ?? this.baseUrl,
      searchUrl: searchUrl ?? this.searchUrl,
      searchList: searchList ?? this.searchList,
      searchName: searchName ?? this.searchName,
      searchResult: searchResult ?? this.searchResult,
      chapterRoads: chapterRoads ?? this.chapterRoads,
      chapterResult: chapterResult ?? this.chapterResult,
      userAgent: userAgent ?? this.userAgent,
      referer: referer ?? this.referer,
      usePost: usePost ?? this.usePost,
      useWebview: useWebview ?? this.useWebview,
      simplified: simplified ?? this.simplified,
    );
  }

  @override
  String toString() => 'KazumiRule($name v$version)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KazumiRule &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          version == other.version;

  @override
  int get hashCode => name.hashCode ^ version.hashCode;
}

/// 预设规则
class PresetRules {
  /// 樱花动漫
  static const KazumiRule yinghua = KazumiRule(
    name: '樱花动漫',
    version: '1.0',
    baseUrl: 'https://www.yinghuaanime.com',
    searchUrl: 'https://www.yinghuaanime.com/search.php?searchword=@keyword',
    searchList: "//ul[@class='stui-vodlist__media col-pd clearfix']//li",
    searchName: "//h3[@class='title']/a",
    searchResult: "//div[@class='thumb']/a",
    chapterRoads: "//ul[@class='stui-content__playlist column10 clearfix']",
    chapterResult: '//li/a',
    referer: 'https://www.yinghuaanime.com',
  );

  /// 获取所有预设规则
  static List<KazumiRule> get all => [yinghua];
}
