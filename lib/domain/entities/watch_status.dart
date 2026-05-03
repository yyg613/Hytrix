/// 观看状态
enum WatchStatusType {
  /// 未观看
  notWatched,

  /// 在看
  watching,

  /// 已看完
  completed,

  /// 已弃番
  dropped,
}

/// 观看状态实体
class WatchStatus {
  final int animeId;
  final WatchStatusType status;
  final int? currentEpisode;
  final int? totalEpisodes;
  final DateTime? updatedAt;

  const WatchStatus({
    required this.animeId,
    required this.status,
    this.currentEpisode,
    this.totalEpisodes,
    this.updatedAt,
  });

  WatchStatus copyWith({
    int? animeId,
    WatchStatusType? status,
    int? currentEpisode,
    int? totalEpisodes,
    DateTime? updatedAt,
  }) {
    return WatchStatus(
      animeId: animeId ?? this.animeId,
      status: status ?? this.status,
      currentEpisode: currentEpisode ?? this.currentEpisode,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
