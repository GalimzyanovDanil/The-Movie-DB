import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/entity/popular_movies/movie.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final List<Movie> _movies = <Movie>[];
  final _scrollController = ScrollController();
  String? _errorMessage;
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

  void setupLocale(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(_locale);
    _movies.clear();
    _currentPage = 0;
    _totalPage = 1;
    loadPopularMovies(context);

    return;
  }

  void onTapMovie({required BuildContext context, required int index}) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  void loadNewPage(int index, BuildContext context) {
    if (index < _movies.length - 1) return;
    loadPopularMovies(context);
  }

  Future<void> loadPopularMovies(BuildContext context) async {
    if (loadingIsProgress || _currentPage >= _totalPage) return;
    loadingIsProgress = true;
    final nextPage = _currentPage + 1;
    try {
      final popularMovies = await _apiClient.popularMovies(nextPage, _locale);
      _currentPage = popularMovies.page;
      _totalPage = popularMovies.totalPages;
      _movies.addAll(popularMovies.movies);
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
}
