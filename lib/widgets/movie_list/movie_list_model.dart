import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/entity/popular_movies/movie.dart';
import 'package:the_movie_db/domain/entity/popular_movies/popular_movies.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final List<Movie> _movies = <Movie>[];
  final _scrollController = ScrollController();
  bool jumpTo = false;
  String? _errorMessage;
  String? _searchQuery;
  Timer? _searchDebounced;
  late DateFormat _dateFormat;
  late String _locale = '';
  late int _currentPage;
  late int _totalPage;
  bool loadingIsProgress = false;
  late SnackBar _snackBar;

  List<Movie> get movies => List.unmodifiable(_movies);
  DateFormat get dateFormat => _dateFormat;
  ScrollController get scrollController => _scrollController;
  String? get errorMessage => _errorMessage;

  set snackBar(SnackBar val) => _snackBar = val;

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(_locale);
    _clearListMovies(context);
    return;
  }

  String dateToString(DateTime? releaseDate) {
    final date = releaseDate != null ? dateFormat.format(releaseDate) : '';
    return date;
  }

  Future<void> onTapMovie(
      {required BuildContext context, required int index}) async {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  void loadNewPage(int index, BuildContext context) {
    if (index < _movies.length - 1) return;
    loadMovies(context);
  }

  Future<void> loadMovies(BuildContext context) async {
    if (loadingIsProgress || _currentPage >= _totalPage) return;
    loadingIsProgress = true;
    final nextPage = _currentPage + 1;
    try {
      final PopularMovies popularMovies;
      if (_searchQuery != null) {
        popularMovies =
            await _apiClient.searchMovies(nextPage, _locale, _searchQuery!);
      } else {
        popularMovies = await _apiClient.popularMovies(nextPage, _locale);
      }

      _currentPage = popularMovies.page;
      _totalPage = popularMovies.totalPages;
      _movies.addAll(popularMovies.movies);
      if (jumpTo) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 2),
          curve: Curves.ease,
        );

        jumpTo = false;
      }
      loadingIsProgress = false;
      _errorMessage = null;

      notifyListeners();
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          _errorMessage = ErrorMessage.network;
          break;
        case DioErrorType.sendTimeout:
          _errorMessage = ErrorMessage.network;
          break;
        case DioErrorType.receiveTimeout:
          _errorMessage = ErrorMessage.network;
          break;
        case DioErrorType.response:
          _errorMessage = ErrorMessage.other;
          break;
        case DioErrorType.cancel:
          _errorMessage = ErrorMessage.other;
          break;
        case DioErrorType.other:
          if (e.error is SocketException) {
            _errorMessage = ErrorMessage.network;
          } else {
            _errorMessage = ErrorMessage.other;
          }
          break;
      }
      showSnackBar(context);
    } catch (e) {
      _errorMessage = ErrorMessage.other;
      showSnackBar(context);
    } finally {
      loadingIsProgress = false;
    }
  }

  void showSnackBar(BuildContext context) {
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    } else {
      return;
    }
  }

  Future<void> searchMovies(BuildContext context, String text) async {
    _searchDebounced?.cancel();
    _searchDebounced = Timer(const Duration(milliseconds: 500), () async {
      _searchQuery = text.isNotEmpty ? text : null;

      await _clearListMovies(context);
    });
  }

  Future<void> _clearListMovies(BuildContext context) async {
    _movies.clear();
    jumpTo = true;
    _currentPage = 0;
    _totalPage = 1;
    await loadMovies(context);
  }
}
