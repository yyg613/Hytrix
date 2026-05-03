/// 分集实体
class Episode {
  final int id;
  final int animeId;
  final String title;
  final int number;
  final String? thumbnailUrl;
  final Duration? duration;
  final DateTime? airDate;

  const Episode({
    required this.id,
    required this.animeId,
    required this.title,
    required this.number,
    this.thumbnailUrl,
    this.duration,
    this.airDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Episode && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
