import 'dart:async';
import 'package:dio/dio.dart';
import 'package:the_movie_db/domain/api_client/configuration_api_client.dart';
import 'package:the_movie_db/domain/entity/movie_detail/movie_detail.dart';
import 'package:the_movie_db/domain/entity/popular_movies/popular_movies.dart';

class MovieApiClient {
  final _dio = Dio(BaseOptions(baseUrl: ConfigurationApiClient.host));

  

  Future<PopularMovies> popularMovies(int page, String locale, String apiKey) async {
    const String path = '/movie/popular';
    final Map<String, dynamic> queryParameters = {
      'api_key': apiKey,
      'language': locale,
      'page': page.toString(),
    };

    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.json,
        ),
        onReceiveProgress: (count, total) {},
      );
      final popularMoviesResponse = PopularMovies.fromJson(response.data);
      return popularMoviesResponse;
    } catch (_) {
      rethrow;
    }
  }

  Future<PopularMovies> searchMovies(
      int page, String locale, String query, String apiKey) async {
    const String path = '/search/movie';
    final Map<String, dynamic> queryParameters = {
      'api_key': apiKey,
      'language': locale,
      'query': query,
      'page': page.toString(),
    };

    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.json,
        ),
        onReceiveProgress: (count, total) {},
      );
      final popularMoviesResponse = PopularMovies.fromJson(response.data);
      return popularMoviesResponse;
    } catch (_) {
      rethrow;
    }
  }

  Future<MovieDetail> movieDetails(int movieId, String locale) async {
    String path = '/movie/$movieId';
    final Map<String, dynamic> queryParameters = {
      'api_key': ConfigurationApiClient.apiKey,
      'language': locale,
      'append_to_response': 'credits,videos',
    };

    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.json,
        ),
        onReceiveProgress: (count, total) {},
      );
      final movieDetails = MovieDetail.fromJson(response.data);
      return movieDetails;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> isFavorite(int movieId, String sessionId) async {
    String path = '/movie/$movieId/account_states';
    final Map<String, dynamic> queryParameters = {
      'api_key': ConfigurationApiClient.apiKey,
      'session_id': sessionId,
    };

    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.json,
        ),
        onReceiveProgress: (count, total) {},
      );
      final result = response.data['favorite'] as bool;
      return result;
    } catch (_) {
      rethrow;
    }
  }
}
