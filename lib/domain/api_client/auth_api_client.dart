import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:the_movie_db/domain/api_client/configuration_api_client.dart';

class AuthApiClient {
  final _dio = Dio(BaseOptions(baseUrl: ConfigurationApiClient.host));

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
    final Map<String, dynamic> queryParameters = {
      'api_key': ConfigurationApiClient.apiKey
    };

    try {
      final response = await _dio.get(path,
          queryParameters: queryParameters,
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
    const String path = '/authentication/token/validate_with_login';
    final Map<String, dynamic> queryParameters = {
      'api_key': ConfigurationApiClient.apiKey
    };
    final bodyParameters = <String, dynamic>{
      'username': username,
      'password': password,
      'request_token': requestToken,
    };

    try {
      final response = await _dio.post(
        path,
        queryParameters: queryParameters,
        data: jsonEncode(bodyParameters),
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
    final bodyParameters = <String, dynamic>{
      'request_token': requestToken,
    };
    const String path = '/authentication/session/new';
    final Map<String, dynamic> queryParameters = {
      'api_key': ConfigurationApiClient.apiKey
    };

    try {
      final response = await _dio.post(
        path,
        queryParameters: queryParameters,
        data: jsonEncode(bodyParameters),
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
}
