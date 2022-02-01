import 'package:the_movie_db/domain/api_client/configuration_api_client.dart';
import 'package:the_movie_db/domain/api_client/exception_api_client.dart';
import 'package:the_movie_db/domain/api_client/movie_api_client.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:the_movie_db/domain/entity/popular_movies/popular_movies.dart';

class MovieService {
  final _movieApiClient = MovieApiClient();
  String? exceptionMessage;

  Future<PopularMovies?> popularMovies(int page, String locale) async {
    try {
      return _movieApiClient.popularMovies(
          page, locale, ConfigurationApiClient.apiKey);
    } on DioError catch (e) {
      exceptionMessage = handleException(e);
    } catch (e) {
      exceptionMessage = ExceptionApiClient.other;
    }
  }

  Future<PopularMovies?> searchMovies(
      int page, String locale, String query) async {
    try {
      return _movieApiClient.searchMovies(
          page, locale, query, ConfigurationApiClient.apiKey);
    } on DioError catch (e) {
      exceptionMessage = handleException(e);
    } catch (e) {
      exceptionMessage = ExceptionApiClient.other;
    }
  }

  String? handleException(DioError exception) {
    final String exceptionMessage;
    switch (exception.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        exceptionMessage = ExceptionApiClient.network;
        break;
      case DioErrorType.response:
      case DioErrorType.cancel:
        exceptionMessage = ExceptionApiClient.other;
        break;
      case DioErrorType.other:
        if (exception.error is SocketException) {
          exceptionMessage = ExceptionApiClient.network;
        } else {
          exceptionMessage = ExceptionApiClient.other;
        }
        break;
    }
    return exceptionMessage;
  }

  // final _paginator = Paginator<Movie>(loadPopularMovies);

  // Future<PopularMovies> loadMovies(String locale, [String? searchQuery]) async {
  //   final PopularMovies movies;
  //   if (searchQuery == null) {
  //     movies = await _movieApiClient.popularMovies(1, locale);
  //   } else {
  //     movies = await _movieApiClient.searchMovies(1, locale, searchQuery);
  //   }
  //   return movies;
  // }

  // Future<PaginatorLoadResult<Movie>> loadPopularMovies(int page) async {
  //   final result = await _movieApiClient.popularMovies(page, locale);
  //   return PaginatorLoadResult<Movie>(currentPage: result.page,totalPage: result.totalPages, data: result.movies);
  // }
}
