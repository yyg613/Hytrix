import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/bangumi_api.dart';
import '../../data/repositories/anime_repository_impl.dart';
import '../../domain/entities/anime.dart';
import '../../domain/entities/episode.dart';
import '../../domain/repositories/anime_repository.dart';

/// 番剧仓库 Provider
final animeRepositoryProvider = Provider<AnimeRepository>((ref) {
  final bangumiApi = ref.watch(bangumiApiProvider);
  return AnimeRepositoryImpl(bangumiApi);
});

/// 新番时间表 Provider
final scheduleProvider = FutureProvider.family<List<Anime>, int?>((ref, weekday) async {
  final repository = ref.watch(animeRepositoryProvider);
  return repository.getSchedule(weekday: weekday);
});

/// 番剧详情 Provider
final animeDetailProvider = FutureProvider.family<Anime, int>((ref, id) async {
  final repository = ref.watch(animeRepositoryProvider);
  return repository.getDetail(id);
});

/// 分集列表 Provider
final episodesProvider = FutureProvider.family<List<Episode>, int>((ref, animeId) async {
  final repository = ref.watch(animeRepositoryProvider);
  return repository.getEpisodes(animeId);
});

/// 搜索状态管理
class SearchNotifier extends StateNotifier<AsyncValue<List<Anime>>> {
  final AnimeRepository _repository;

  SearchNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final results = await _repository.search(query);
      state = AsyncValue.data(results);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

/// 搜索 Provider
final searchProvider = StateNotifierProvider<SearchNotifier, AsyncValue<List<Anime>>>((ref) {
  final repository = ref.watch(animeRepositoryProvider);
  return SearchNotifier(repository);
});
