import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';

/// Bangumi API 数据源
class BangumiApi {
  final Dio _dio;

  BangumiApi(this._dio);

  /// 获取每日放送
  Future<List<dynamic>> getCalendar() async {
    final response = await _dio.get('/calendar');
    return response.data as List;
  }

  /// 获取条目信息
  Future<Map<String, dynamic>> getSubject(int id) async {
    final response = await _dio.get('/v0/subjects/$id');
    return response.data as Map<String, dynamic>;
  }

  /// 获取条目剧集
  Future<List<dynamic>> getEpisodes(int subjectId) async {
    final response = await _dio.get('/v0/episodes', queryParameters: {
      'subject_id': subjectId,
    });
    return (response.data as Map<String, dynamic>)['data'] as List;
  }

  /// 搜索条目
  Future<Map<String, dynamic>> searchSubjects(String keyword) async {
    final response = await _dio.post(
      '/search/subject/${Uri.encodeComponent(keyword)}',
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return response.data as Map<String, dynamic>;
  }
}

/// Bangumi API Provider
final bangumiApiProvider = Provider<BangumiApi>((ref) {
  final dio = ref.watch(dioProvider);
  return BangumiApi(dio);
});
