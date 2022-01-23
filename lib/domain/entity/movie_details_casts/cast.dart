import 'package:json_annotation/json_annotation.dart';

part 'cast.g.dart';

@JsonSerializable()
class Cast {
  final bool adult;
  final int? gender;
  final int id;
  @JsonKey(name: 'known_for_department')
  final String knownForDepartment;
  final String name;
  @JsonKey(name: 'original_name')
  final String originalName;
  final double popularity;
  @JsonKey(name: 'profile_path')
  final String? profilePath;
  @JsonKey(name: 'cast_id')
  final int castId;
  final String character;
  @JsonKey(name: 'credit_id')
  final String creditId;
  final int order;

  const Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);

  Map<String, dynamic> toJson() => _$CastToJson(this);
}
