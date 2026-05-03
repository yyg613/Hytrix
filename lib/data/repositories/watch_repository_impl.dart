import 'package:drift/drift.dart';

import '../../core/error/exceptions.dart';
import '../../domain/entities/watch_status.dart';
import '../../domain/repositories/watch_repository.dart';
import '../datasources/local/drift_database.dart';

/// 观看仓库实现
class WatchRepositoryImpl implements WatchRepository {
  final AppDatabase _database;

  WatchRepositoryImpl(this._database);

  @override
  Future<List<WatchStatus>> getAllWatchStatus() async {
    try {
      final trackingList = await _database.getAllTracking();
      return trackingList.map(_mapToWatchStatus).toList();
    } catch (e) {
      throw CacheException(message: '获取观看状态失败: $e');
    }
  }

  @override
  Future<WatchStatus?> getWatchStatus(int animeId) async {
    try {
      final tracking = await _database.getTracking(animeId);
      return tracking != null ? _mapToWatchStatus(tracking) : null;
    } catch (e) {
      throw CacheException(message: '获取观看状态失败: $e');
    }
  }

  @override
  Future<void> updateWatchStatus(WatchStatus status) async {
    try {
      await _database.insertTracking(
        AnimeTrackingCompanion(
          animeId: Value(status.animeId),
          status: Value(status.status.name),
          currentEpisode: Value(status.currentEpisode ?? 0),
          totalEpisodes: Value(status.totalEpisodes),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } catch (e) {
      throw CacheException(message: '更新观看状态失败: $e');
    }
  }

  @override
  Future<void> deleteWatchStatus(int animeId) async {
    try {
      await _database.deleteTracking(animeId);
    } catch (e) {
      throw CacheException(message: '删除观看状态失败: $e');
    }
  }

  @override
  Future<List<WatchStatus>> getWatchHistory({int limit = 50}) async {
    try {
      final history = await _database.getWatchHistory(limit: limit);
      return history.map((item) => WatchStatus(
        animeId: item.animeId,
        status: WatchStatusType.watching,
        currentEpisode: item.progress,
        updatedAt: item.watchedAt,
      )).toList();
    } catch (e) {
      throw CacheException(message: '获取观看历史失败: $e');
    }
  }

  WatchStatus _mapToWatchStatus(AnimeTrackingData data) {
    return WatchStatus(
      animeId: data.animeId,
      status: WatchStatusType.values.firstWhere(
        (e) => e.name == data.status,
        orElse: () => WatchStatusType.notWatched,
      ),
      currentEpisode: data.currentEpisode,
      totalEpisodes: data.totalEpisodes,
      updatedAt: data.updatedAt,
    );
  }
}
