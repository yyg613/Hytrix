import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/dio_client.dart';
import '../../data/datasources/remote/bangumi_api.dart';
import '../../data/datasources/local/drift_database.dart';
import '../../data/models/watch_history.dart';
import '../../domain/entities/watch_status.dart';
import '../../data/repositories/watch_repository_impl.dart';
import '../../domain/repositories/watch_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final watchRepositoryProvider = Provider<WatchRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return WatchRepositoryImpl(db);
});

class TrackingNotifier extends StateNotifier<AsyncValue<List<WatchStatus>>> {
  final WatchRepository _repository;

  TrackingNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> loadAll() async {
    state = const AsyncValue.loading();
    try {
      final list = await _repository.getAllWatchStatus();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<WatchStatus?> getStatus(int animeId) async {
    try {
      return await _repository.getWatchStatus(animeId);
    } catch (e) {
      return null;
    }
  }

  Future<void> toggleTracking(int animeId, WatchStatusType status,
      {int? totalEpisodes}) async {
    await _repository.updateWatchStatus(WatchStatus(
      animeId: animeId,
      status: status,
      currentEpisode: 0,
      totalEpisodes: totalEpisodes,
      updatedAt: DateTime.now(),
    ));
    await loadAll();
  }

  Future<void> updateProgress(int animeId, int episode,
      {int? totalEpisodes}) async {
    final existing = await _repository.getWatchStatus(animeId);
    await _repository.updateWatchStatus(WatchStatus(
      animeId: animeId,
      status: existing?.status ?? WatchStatusType.watching,
      currentEpisode: episode,
      totalEpisodes: totalEpisodes ?? existing?.totalEpisodes,
      updatedAt: DateTime.now(),
    ));
    await loadAll();
  }

  Future<void> removeTracking(int animeId) async {
    await _repository.deleteWatchStatus(animeId);
    await loadAll();
  }

  List<WatchStatus> getByStatus(WatchStatusType status) {
    final list = state.valueOrNull ?? [];
    return list.where((w) => w.status == status).toList();
  }
}

final trackingProvider =
    StateNotifierProvider<TrackingNotifier, AsyncValue<List<WatchStatus>>>(
        (ref) {
  final repo = ref.watch(watchRepositoryProvider);
  return TrackingNotifier(repo);
});
