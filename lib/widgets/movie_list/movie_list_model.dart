import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/entity/popular_movies/movie.dart';
import 'package:the_movie_db/domain/entity/popular_movies/popular_movies.dart';
import 'package:the_movie_db/domain/service/movie_service.dart';
import 'package:the_movie_db/library/paginator.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class MovieData {
  final int id;
  final String? posterPath;
  final String releaseDate;
  final String title;
  final String overview;

  MovieData(
      {required this.id,
      required this.posterPath,
      required this.releaseDate,
      required this.title,
      required this.overview});
}

class MovieListWidgetModel extends ChangeNotifier {
  final _movieService = MovieService();
  final BuildContext context;

  final List<MovieData> _movies = <MovieData>[];
  final _scrollController = ScrollController();
  bool jumpTo = false;
  String? _exceptionMessage;
  String? _searchQuery;
  Timer? _searchDebounced;

  late String _locale = '';
  late SnackBar _snackBar;

  late final Paginator<Movie> moviesPaginator;

  MovieListWidgetModel(this.context) {
    moviesPaginator = Paginator<Movie>(
      loader: (page) async {
        final PopularMovies? movies;
        final searchQuery = _searchQuery;
        if (searchQuery == null) {
          movies = await _movieService.popularMovies(page, _locale);
        } else {
          movies = await _movieService.searchMovies(page, _locale, searchQuery);
        }
        return PaginatorLoadResult<Movie>(
          data: movies?.movies,
          currentPage: movies?.page,
          totalPage: movies?.totalPages,
        );
      },
    );
  }

  List<MovieData> get movies => List.unmodifiable(_movies);
  ScrollController get scrollController => _scrollController;
  String? get exceptionMessage => _exceptionMessage;

  set snackBar(SnackBar val) => _snackBar = val;

  Future<void> setupLocale() async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _clearListMovies();
    return;
  }

  void loadNewPage(int index) {
    if (index < _movies.length - 1) return;
    loadMovies();
  }

  Future<void> loadMovies() async {
    await moviesPaginator.loadNextPage();
    _movies.addAll(moviesPaginator.data.map(
      (Movie movie) {
        return _makeMovieData(movie);
      },
    ).toList());

    if (jumpTo) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.ease,
      );
      jumpTo = false;
    }
    _exceptionMessage = null;
    notifyListeners();
  }

  Future<void> searchMovies(String text) async {
    _searchDebounced?.cancel();
    _searchDebounced = Timer(const Duration(milliseconds: 500), () async {
      _searchQuery = text.isNotEmpty ? text : null;
      await _clearListMovies();
    });
  }

  Future<void> onTapMovie({required int index}) async {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  void showSnackBar() {
    if (exceptionMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    } else {
      return;
    }
  }

  Future<void> _clearListMovies() async {
    _movies.clear();
    jumpTo = true;
    moviesPaginator.reset();
    await loadMovies();
  }

  MovieData _makeMovieData(Movie movie) {
    final dateFormat = DateFormat.yMMMMd(_locale);
    final releaseDate = movie.releaseDate;
    final String releaseDateString =
        releaseDate != null ? dateFormat.format(releaseDate) : '';

    final movieData = MovieData(
        id: movie.id,
        overview: movie.overview,
        posterPath: movie.posterPath,
        title: movie.title,
        releaseDate: releaseDateString);
    return movieData;
  }
}
