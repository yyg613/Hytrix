import 'package:json_annotation/json_annotation.dart';

part 'anime_model.g.dart';

/// 番剧数据模型
@JsonSerializable()
class AnimeModel {
  final int id;
  final String name;
  final String? nameCn;
  final String? summary;
  final String? image;
  final double? rating;
  final List<String>? tags;
  @JsonKey(name: 'air_date')
  final String? airDate;
  @JsonKey(name: 'eps_count')
  final int? epsCount;

  const AnimeModel({
    required this.id,
    required this.name,
    this.nameCn,
    this.summary,
    this.image,
    this.rating,
    this.tags,
    this.airDate,
    this.epsCount,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) =>
      _$AnimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeModelToJson(this);
}
