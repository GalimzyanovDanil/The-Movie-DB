import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  final bool adult;
  final String overview;
  @JsonKey(
    name: 'release_date',
    fromJson: _verifyDateTime,
  )
  final DateTime? releaseDate;
  @JsonKey(name: 'genre_ids')
  final List<int> genreIds;
  final int id;
  @JsonKey(name: 'original_title')
  final String originalTitle;
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  final String title;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  final double popularity;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  final bool video;
  @JsonKey(name: 'vote_average')
  final double voteAverage;

  const Movie({
    required this.posterPath,
    required this.adult,
    required this.overview,
    required this.releaseDate,
    required this.genreIds,
    required this.id,
    required this.originalTitle,
    required this.originalLanguage,
    required this.title,
    required this.backdropPath,
    required this.popularity,
    required this.voteCount,
    required this.video,
    required this.voteAverage,
  });

  @override
  String toString() {
    return 'Result(posterPath: $posterPath, adult: $adult, overview: $overview, releaseDate: $releaseDate, genreIds: $genreIds, id: $id, originalTitle: $originalTitle, originalLanguage: $originalLanguage, title: $title, backdropPath: $backdropPath, popularity: $popularity, voteCount: $voteCount, video: $video, voteAverage: $voteAverage)';
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return _$MovieFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MovieToJson(this);

  static DateTime? _verifyDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return null;
    }
    return DateTime.tryParse(dateTimeString);
  }

  
}
