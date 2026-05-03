import '../entities/watch_status.dart';

/// 观看仓库接口
abstract class WatchRepository {
  /// 获取所有观看状态
  Future<List<WatchStatus>> getAllWatchStatus();

  /// 获取单个番剧的观看状态
  Future<WatchStatus?> getWatchStatus(int animeId);

  /// 更新观看状态
  Future<void> updateWatchStatus(WatchStatus status);

  /// 删除观看状态
  Future<void> deleteWatchStatus(int animeId);

  /// 获取观看历史
  Future<List<WatchStatus>> getWatchHistory({int limit = 50});
}
