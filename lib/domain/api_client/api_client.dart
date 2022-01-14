//b593c6b73d3038c9c91fa46b4acad05d

import 'dart:convert';

import 'package:dio/dio.dart';

class ApiClient {
  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500/';
  static const _apiKey = 'b593c6b73d3038c9c91fa46b4acad05d';

  final _dio = Dio();

  Future<String> authRequest({
    required String username,
    required String password,
  }) async {
    final requestToken = await _getToken();
    final validToken = await _validateUser(
        username: username, password: password, requestToken: requestToken);
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Future<String> _getToken() async {
    const String path = '/authentication/token/new';
    Uri uri = _makeUri(path, <String, dynamic>{'api_key': _apiKey});

    final response = await _dio.getUri(uri,
        options: Options(
          responseType: ResponseType.json,
        ));
    final token = response.data['request_token'];
    return token;
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
  }

  Future<String> _makeSession({required String requestToken}) async {
    final parameters = <String, dynamic>{
      'request_token': requestToken,
    };

    const String path = '/authentication/session/new';
    Uri uri = _makeUri(path, <String, dynamic>{'api_key': _apiKey});

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
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    }
    return uri;
  }
}
