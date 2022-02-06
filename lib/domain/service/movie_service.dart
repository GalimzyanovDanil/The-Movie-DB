import 'package:the_movie_db/domain/api_client/configuration_api_client.dart';
import 'package:the_movie_db/domain/api_client/exception_api_client.dart';
import 'package:the_movie_db/domain/api_client/movie_api_client.dart';
import 'package:dio/dio.dart';
import 'package:the_movie_db/domain/entity/popular_movies/popular_movies.dart';

class MovieService {
  final _movieApiClient = MovieApiClient();
  final _exceptionApiClient = ExceptionApiClient();
  String? _exceptionMessage;
  String? get exceptionMessage => _exceptionMessage;

  Future<PopularMovies?> popularMovies(int page, String locale) async {
    try {
      _exceptionMessage = null;
      return _movieApiClient.popularMovies(
          page, locale, ConfigurationApiClient.apiKey);
    } on DioError catch (e) {
      _exceptionMessage = _exceptionApiClient.handleException(e);
    } catch (e) {
      _exceptionMessage = ExceptionApiClient.other;
    }
  }

  Future<PopularMovies?> searchMovies(
      int page, String locale, String query) async {
    try {
      _exceptionMessage = null;
      return _movieApiClient.searchMovies(
          page, locale, query, ConfigurationApiClient.apiKey);
    } on DioError catch (e) {
      _exceptionMessage = _exceptionApiClient.handleException(e);
    } catch (e) {
      _exceptionMessage = ExceptionApiClient.other;
    }
  }
}
