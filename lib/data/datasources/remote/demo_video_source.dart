import 'video_source.dart';

/// 示例视频源 - 用于测试
class DemoVideoSource implements VideoSource {
  @override
  String get name => '示例源';

  @override
  String? get iconUrl => null;

  @override
  Future<VideoInfo?> resolve(String animeName, int episode) async {
    // 返回示例视频用于测试
    // 使用公开的测试视频
    return VideoInfo(
      url: 'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4',
      title: '$animeName - 第$episode集',
      quality: '720P',
    );
  }
}

/// 自定义视频源 - 用户手动输入
class CustomVideoSource implements VideoSource {
  final String videoUrl;
  final String sourceName;

  CustomVideoSource({
    required this.videoUrl,
    this.sourceName = '自定义源',
  });

  @override
  String get name => sourceName;

  @override
  String? get iconUrl => null;

  @override
  Future<VideoInfo?> resolve(String animeName, int episode) async {
    return VideoInfo(
      url: videoUrl,
      title: '$animeName - 第$episode集',
    );
  }
}
