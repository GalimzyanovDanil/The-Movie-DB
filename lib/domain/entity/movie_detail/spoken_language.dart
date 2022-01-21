import 'package:json_annotation/json_annotation.dart';

part 'spoken_language.g.dart';

@JsonSerializable()
class SpokenLanguage {
  @JsonKey(name: 'iso_639_1')
  final String iso6391;
  final String name;

  const SpokenLanguage({required this.iso6391, required this.name});

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return _$SpokenLanguageFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SpokenLanguageToJson(this);
}
