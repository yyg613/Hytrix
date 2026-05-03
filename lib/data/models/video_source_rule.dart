/// 视频源规则模型
/// 
/// 参考 Kazumi 的规则系统，使用 Xpath 选择器解析网页
class VideoSourceRule {
  final String name;
  final String baseUrl;
  final String searchUrl;
  final String searchList;
  final String searchName;
  final String searchDetail;
  final String detailUrl;
  final String episodeList;
  final String episodeName;
  final String episodeUrl;
  final String? userAgent;
  final Map<String, String>? headers;

  const VideoSourceRule({
    required this.name,
    required this.baseUrl,
    required this.searchUrl,
    required this.searchList,
    required this.searchName,
    required this.searchDetail,
    required this.detailUrl,
    required this.episodeList,
    required this.episodeName,
    required this.episodeUrl,
    this.userAgent,
    this.headers,
  });

  /// 从 JSON 创建
  factory VideoSourceRule.fromJson(Map<String, dynamic> json) {
    return VideoSourceRule(
      name: json['name'] as String,
      baseUrl: json['baseUrl'] as String,
      searchUrl: json['searchUrl'] as String,
      searchList: json['searchList'] as String,
      searchName: json['searchName'] as String,
      searchDetail: json['searchDetail'] as String,
      detailUrl: json['detailUrl'] as String,
      episodeList: json['episodeList'] as String,
      episodeName: json['episodeName'] as String,
      episodeUrl: json['episodeUrl'] as String,
      userAgent: json['userAgent'] as String?,
      headers: json['headers'] != null
          ? Map<String, String>.from(json['headers'] as Map)
          : null,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'baseUrl': baseUrl,
      'searchUrl': searchUrl,
      'searchList': searchList,
      'searchName': searchName,
      'searchDetail': searchDetail,
      'detailUrl': detailUrl,
      'episodeList': episodeList,
      'episodeName': episodeName,
      'episodeUrl': episodeUrl,
      if (userAgent != null) 'userAgent': userAgent,
      if (headers != null) 'headers': headers,
    };
  }
}

/// 预设规则示例
class PresetRules {
  /// 获取预设规则列表
  static List<VideoSourceRule> get presets => [
    // 这里可以添加预设规则
    // 用户也可以导入自定义规则
  ];
}
