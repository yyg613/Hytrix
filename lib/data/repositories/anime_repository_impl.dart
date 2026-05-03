import 'package:dio/dio.dart';

import '../../core/error/exceptions.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/episode.dart';
import '../../domain/repositories/anime_repository.dart';
import '../datasources/remote/bangumi_api.dart';

/// 番剧仓库实现
class AnimeRepositoryImpl implements AnimeRepository {
  final BangumiApi _bangumiApi;

  AnimeRepositoryImpl(this._bangumiApi);

  @override
  Future<List<Anime>> getSchedule({int? weekday}) async {
    try {
      final calendar = await _bangumiApi.getCalendar();
      final List<Anime> animes = [];

      for (final day in calendar) {
        final weekdayItems = day['weekday']?['id'];
        if (weekday != null && weekdayItems != weekday) continue;

        final items = day['items'] as List? ?? [];
        for (final item in items) {
          animes.add(_mapToAnime(item));
        }
      }

      return animes;
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? '网络请求失败',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ParseException(message: '数据解析失败: $e');
    }
  }

  @override
  Future<List<Anime>> getPopular({int page = 1, int pageSize = 20}) async {
    // Bangumi API 没有直接的热门接口，使用搜索模拟
    try {
      final result = await _bangumiApi.searchSubjects('');
      final List<dynamic> data = result['data'] ?? [];
      return data.map((item) => _mapToAnime(item)).toList();
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? '网络请求失败',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ParseException(message: '数据解析失败: $e');
    }
  }

  @override
  Future<List<Anime>> getTopRated({int page = 1, int pageSize = 20}) async {
    // 类似 getPopular
    return getPopular(page: page, pageSize: pageSize);
  }

  @override
  Future<List<Anime>> search(String query, {int page = 1, int pageSize = 20}) async {
    try {
      final result = await _bangumiApi.searchSubjects(query);
      final List<dynamic> data = result['data'] ?? [];
      return data.map((item) => _mapToAnime(item)).toList();
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? '网络请求失败',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ParseException(message: '数据解析失败: $e');
    }
  }

  @override
  Future<Anime> getDetail(int id) async {
    try {
      final data = await _bangumiApi.getSubject(id);
      return _mapToAnime(data);
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? '网络请求失败',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ParseException(message: '数据解析失败: $e');
    }
  }

  @override
  Future<List<Episode>> getEpisodes(int animeId) async {
    try {
      final data = await _bangumiApi.getEpisodes(animeId);
      return data.map((item) => _mapToEpisode(item, animeId)).toList();
    } on DioException catch (e) {
      throw NetworkException(
        message: e.message ?? '网络请求失败',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ParseException(message: '数据解析失败: $e');
    }
  }

  Anime _mapToAnime(Map<String, dynamic> data) {
    return Anime(
      id: data['id'] as int,
      title: data['name'] as String? ?? data['name_cn'] as String? ?? '',
      imageUrl: data['images']?['large'] as String?,
      description: data['summary'] as String?,
      rating: (data['rating']?['score'] as num?)?.toDouble(),
      totalEpisodes: data['eps_count'] as int?,
    );
  }

  Episode _mapToEpisode(Map<String, dynamic> data, int animeId) {
    return Episode(
      id: data['id'] as int,
      animeId: animeId,
      title: data['name'] as String? ?? data['name_cn'] as String? ?? '',
      number: data['sort'] as int? ?? 0,
    );
  }
}
