import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:the_movie_db/domain/entity/popular_movies/popular_movies.dart';

// enum ApiClientExceptionType { network, auth, other }

// class ApiClientException {
//   final ApiClientExceptionType type;

//   ApiClientException(this.type);
// }

class ApiClient {
  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = 'b593c6b73d3038c9c91fa46b4acad05d';

  static String createPosterPath(String posterPath) {
    return _imageUrl + posterPath;
  }

  final _dio = Dio();

  Future<String> authRequest({
    required String username,
    required String password,
  }) async {
    BaseOptions();

    final requestToken = await _getToken();
    final validToken = await _validateUser(
        username: username, password: password, requestToken: requestToken);
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Future<String> _getToken() async {
    const String path = '/authentication/token/new';
    Uri uri = _makeUri(path, <String, dynamic>{'api_key': _apiKey});

    try {
      final response = await _dio.getUri(uri,
          options: Options(
            responseType: ResponseType.json,
          ));
      final token = response.data['request_token'];
      return token;
    } catch (_) {
      rethrow;
    }
  }

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final parameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };
    const String path = '/authentication/token/validate_with_login';
    Uri uri = _makeUri(path, <String, dynamic>{'api_key': _apiKey});

    try {
      final response = await _dio.postUri(
        uri,
        data: jsonEncode(parameters),
        options: Options(
          responseType: ResponseType.json,
        ),
        onReceiveProgress: (count, total) {},
      );
      final token = response.data['request_token'];
      return token;
    } catch (_) {
      rethrow;
    }
  }

  Future<String> _makeSession({required String requestToken}) async {
    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };
    const String path = '/authentication/session/new';
    Uri uri = _makeUri(path, <String, dynamic>{'api_key': _apiKey});

    try {
      final response = await _dio.postUri(
        uri,
        data: jsonEncode(parameters),
        options: Options(
          responseType: ResponseType.json,
        ),
        onReceiveProgress: (count, total) {},
      );
      final sessionId = response.data['session_id'];
      return sessionId;
    } catch (_) {
      rethrow;
    }
  }

  Future<PopularMovies> popularMovies(int page, String locale) async {
    const String path = '/movie/popular';
    final Map<String, dynamic> queryParameters = {
      'api_key': _apiKey,
      'language': locale,
      'page': page.toString(),
    };
    Uri uri = _makeUri(path, queryParameters);
    try {
      final response = await _dio.getUri(
        uri,
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

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    }
    return uri;
  }

  Future<PopularMovies> searchMovies(
      int page, String locale, String query) async {
    const String path = '/search/movie';
    final Map<String, dynamic> queryParameters = {
      'api_key': _apiKey,
      'language': locale,
      'query': query,
      'page': page.toString(),
    };
    Uri uri = _makeUri(path, queryParameters);
    try {
      final response = await _dio.getUri(
        uri,
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
}

class ErrorMessage {
  static const network = 'Ошибка подключения. Проверьте интернет соединение';
  static const auth = 'Неверный логин или пароль!';
  static const other = 'Произошла ошибка. Попробуйте повторить';
}
