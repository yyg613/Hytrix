/// 视频源接口
abstract class VideoSource {
  /// 数据源名称
  String get name;

  /// 数据源图标
  String? get iconUrl;

  /// 解析视频地址
  Future<VideoInfo?> resolve(String animeName, int episode);
}

/// 视频信息
class VideoInfo {
  final String url;
  final String? title;
  final String? quality;
  final Map<String, String>? headers;

  const VideoInfo({
    required this.url,
    this.title,
    this.quality,
    this.headers,
  });
}

/// 视频源异常
class VideoSourceException implements Exception {
  final String message;
  VideoSourceException(this.message);

  @override
  String toString() => message;
}
