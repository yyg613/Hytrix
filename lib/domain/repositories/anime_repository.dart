import '../entities/anime.dart';
import '../entities/episode.dart';

/// 番剧仓库接口
abstract class AnimeRepository {
  /// 获取新番时间表
  Future<List<Anime>> getSchedule({int? weekday});

  /// 获取热门番剧
  Future<List<Anime>> getPopular({int page = 1, int pageSize = 20});

  /// 获取高分番剧
  Future<List<Anime>> getTopRated({int page = 1, int pageSize = 20});

  /// 搜索番剧
  Future<List<Anime>> search(String query, {int page = 1, int pageSize = 20});

  /// 获取番剧详情
  Future<Anime> getDetail(int id);

  /// 获取分集列表
  Future<List<Episode>> getEpisodes(int animeId);
}
