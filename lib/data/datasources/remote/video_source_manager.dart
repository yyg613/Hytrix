import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html_parser;

import '../../data/models/video_source_rule.dart';
import '../../data/datasources/remote/video_source.dart';
import '../../core/network/dio_client.dart';

/// 视频源管理器
/// 
/// 管理所有视频源，提供统一的解析接口
class VideoSourceManager {
  final List<VideoSource> _sources = [];

  VideoSourceManager();

  /// 添加视频源
  void addSource(VideoSource source) {
    _sources.add(source);
  }

  /// 移除视频源
  void removeSource(VideoSource source) {
    _sources.remove(source);
  }

  /// 获取所有视频源
  List<VideoSource> get sources => List.unmodifiable(_sources);

  /// 解析视频
  Future<VideoInfo?> resolve(String animeName, int episode) async {
    for (final source in _sources) {
      try {
        final result = await source.resolve(animeName, episode);
        if (result != null) return result;
      } catch (e) {
        continue;
      }
    }
    return null;
  }
}

/// 视频源管理器 Provider
final videoSourceManagerProvider = Provider<VideoSourceManager>((ref) {
  return VideoSourceManager();
});

/// 视频源规则存储
class VideoSourceRuleStorage {
  final List<VideoSourceRule> _rules = [];

  List<VideoSourceRule> get rules => List.unmodifiable(_rules);

  void addRule(VideoSourceRule rule) {
    _rules.add(rule);
  }

  void removeRule(VideoSourceRule rule) {
    _rules.remove(rule);
  }

  void clear() {
    _rules.clear();
  }
}

/// 视频源规则存储 Provider
final videoSourceRuleStorageProvider = Provider<VideoSourceRuleStorage>((ref) {
  return VideoSourceRuleStorage();
});
