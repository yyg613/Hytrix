/// 番剧实体
class Anime {
  final int id;
  final String title;
  final String? imageUrl;
  final String? description;
  final double? rating;
  final List<String>? tags;
  final DateTime? airDate;
  final int? totalEpisodes;

  const Anime({
    required this.id,
    required this.title,
    this.imageUrl,
    this.description,
    this.rating,
    this.tags,
    this.airDate,
    this.totalEpisodes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Anime && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
