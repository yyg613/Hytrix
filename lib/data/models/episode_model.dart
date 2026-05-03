import 'package:json_annotation/json_annotation.dart';

part 'episode_model.g.dart';

/// 分集数据模型
@JsonSerializable()
class EpisodeModel {
  final int id;
  @JsonKey(name: 'subject_id')
  final int subjectId;
  final String name;
  @JsonKey(name: 'name_cn')
  final String? nameCn;
  final int sort;
  @JsonKey(name: 'duration')
  final String? duration;
  @JsonKey(name: 'airdate')
  final String? airDate;

  const EpisodeModel({
    required this.id,
    required this.subjectId,
    required this.name,
    this.nameCn,
    required this.sort,
    this.duration,
    this.airDate,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeModelToJson(this);
}
