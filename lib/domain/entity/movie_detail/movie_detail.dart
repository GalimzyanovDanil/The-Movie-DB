import 'package:json_annotation/json_annotation.dart';
import 'package:the_movie_db/domain/entity/convert.dart';
import 'package:the_movie_db/domain/entity/movie_details_casts/movie_details_casts.dart';
import 'package:the_movie_db/domain/entity/movie_details_video/movie_details_video.dart';

import 'genre.dart';
import 'production_company.dart';
import 'production_country.dart';
import 'spoken_language.dart';

part 'movie_detail.g.dart';

@JsonSerializable(explicitToJson: true)
class MovieDetail {
  final bool adult;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'belongs_to_collection')
  final Object? belongsToCollection;
  final int budget;
  final List<Genre> genres;
  final String? homepage;
  final int id;
  @JsonKey(name: 'imdb_id')
  final String? imdbId;
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  @JsonKey(name: 'original_title')
  final String originalTitle;
  final String? overview;
  final double popularity;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'production_companies')
  final List<ProductionCompany> productionCompanies;
  @JsonKey(name: 'production_countries')
  final List<ProductionCountry> productionCountries;
  @JsonKey(
    name: 'release_date',
    fromJson: verifyDateTime,
  )
  final DateTime? releaseDate;
  final int revenue;
  final int? runtime;
  @JsonKey(name: 'spoken_languages')
  final List<SpokenLanguage> spokenLanguages;
  final String status;
  final String? tagline;
  final String title;
  final bool video;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  final MovieDetailsCasts credits;
  final MovieDetailsVideo videos;

  const MovieDetail({
    required this.adult,
    required this.backdropPath,
    required this.belongsToCollection,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.credits,
    required this.videos,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return _$MovieDetailFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MovieDetailToJson(this);
}
