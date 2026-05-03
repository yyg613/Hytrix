import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/kazumi_rule.dart';
import '../../data/datasources/remote/video_source.dart';
import '../../data/datasources/remote/demo_video_source.dart';
import '../../data/datasources/remote/rule_video_source.dart';

/// 视频源列表 Notifier
class VideoSourcesNotifier extends StateNotifier<List<VideoSource>> {
  VideoSourcesNotifier(List<VideoSource> sources) : super(sources);

  void addSource(VideoSource source) {
    state = [...state, source];
  }

  void removeSource(VideoSource source) {
    state = state.where((s) => s != source).toList();
  }

  void clear() {
    state = [];
  }
}

/// 视频源列表 Provider
final videoSourcesProvider =
    StateNotifierProvider<VideoSourcesNotifier, List<VideoSource>>((ref) {
  return VideoSourcesNotifier([
    RuleVideoSource(PresetRules.yinghua),
    DemoVideoSource(),
  ]);
});

/// 当前选中的视频源
final selectedVideoSourceProvider = StateProvider<VideoSource?>((ref) {
  final sources = ref.watch(videoSourcesProvider);
  return sources.isNotEmpty ? sources.first : null;
});

/// 视频解析状态
class VideoResolveState {
  final bool isLoading;
  final VideoInfo? videoInfo;
  final String? error;

  const VideoResolveState({
    this.isLoading = false,
    this.videoInfo,
    this.error,
  });

  VideoResolveState copyWith({
    bool? isLoading,
    VideoInfo? videoInfo,
    String? error,
  }) {
    return VideoResolveState(
      isLoading: isLoading ?? this.isLoading,
      videoInfo: videoInfo ?? this.videoInfo,
      error: error,
    );
  }
}

/// 视频解析 Notifier
class VideoResolveNotifier extends StateNotifier<VideoResolveState> {
  VideoResolveNotifier() : super(const VideoResolveState());

  Future<void> resolve(VideoSource source, String animeName, int episode) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final videoInfo = await source.resolve(animeName, episode);
      state = state.copyWith(isLoading: false, videoInfo: videoInfo);
    } catch (e) {
      String errorMessage;
      if (e is VideoSourceException) {
        errorMessage = e.message;
      } else {
        errorMessage = '解析失败: $e';
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    }
  }

  void clear() {
    state = const VideoResolveState();
  }
}

/// 视频解析 Provider
final videoResolveProvider =
    StateNotifierProvider<VideoResolveNotifier, VideoResolveState>((ref) {
  return VideoResolveNotifier();
});
