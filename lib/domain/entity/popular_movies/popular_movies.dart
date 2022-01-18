import 'package:json_annotation/json_annotation.dart';

import 'movie.dart';

part 'popular_movies.g.dart';

@JsonSerializable(explicitToJson: true) //при использовании вложенных классов
class PopularMovies {
  final int page;
  @JsonKey(name: 'results')
  final List<Movie> movies;
  @JsonKey(name: 'total_results')
  final int totalResults;
  @JsonKey(name: 'total_pages')
  final int totalPages;

  const PopularMovies({
    required this.page,
    required this.movies,
    required this.totalResults,
    required this.totalPages,
  });

  @override
  String toString() {
    return 'PopularMovies(page: $page, results: $movies, totalResults: $totalResults, totalPages: $totalPages)';
  }

  factory PopularMovies.fromJson(Map<String, dynamic> json) {
    return _$PopularMoviesFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PopularMoviesToJson(this);
}
