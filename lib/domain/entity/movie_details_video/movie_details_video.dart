import 'package:json_annotation/json_annotation.dart';

import 'result.dart';

part 'movie_details_video.g.dart';

@JsonSerializable()
class MovieDetailsVideo {
  
  final List<Result> results;

  const MovieDetailsVideo({required this.results});

  factory MovieDetailsVideo.fromJson(Map<String, dynamic> json) {
    return _$MovieDetailsVideoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MovieDetailsVideoToJson(this);
}
