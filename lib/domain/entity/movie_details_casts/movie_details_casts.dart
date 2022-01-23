import 'package:json_annotation/json_annotation.dart';

import 'cast.dart';
import 'crew.dart';

part 'movie_details_casts.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieDetailsCasts {
  final List<Cast>? cast;
  final List<Crew>? crew;

  const MovieDetailsCasts({this.cast, this.crew});

  factory MovieDetailsCasts.fromJson(Map<String, dynamic> json) {
    return _$MovieDetailsCastsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MovieDetailsCastsToJson(this);
}
