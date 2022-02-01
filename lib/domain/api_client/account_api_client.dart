import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:the_movie_db/domain/api_client/configuration_api_client.dart';

enum mediaType { movie, tv }

extension MediaTypeString on mediaType {
  String asString() {
    switch (this) {
      case mediaType.movie:
        return 'movie';
      case mediaType.tv:
        return 'tv';
    }
  }
}

class AccountApiClient {
  final _dio = Dio(BaseOptions(baseUrl: ConfigurationApiClient.host));

  Future<int> getAccountId(String sessionId) async {
    const String path = '/account';
    final queryParameters = <String, dynamic>{
      'api_key': ConfigurationApiClient.apiKey,
      'session_id': sessionId
    };

    try {
      final response = await _dio.get(path,
          queryParameters: queryParameters,
          options: Options(
            responseType: ResponseType.json,
          ));
      final accountId = response.data['id'];
      return accountId;
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> markAsFavorite(
      {required mediaType mediaType,
      required int mediaId,
      required bool favorite,
      required String sessionId,
      required int accountId}) async {
    final String path = '/account/$accountId/favorite';
    final Map<String, dynamic> queryParameters = {
      'api_key': ConfigurationApiClient.apiKey,
      'session_id': sessionId
    };
    final bodyParameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId,
      'favorite': favorite,
    };

    try {
      final response = await _dio.post(
        path,
        queryParameters: queryParameters,
        data: jsonEncode(bodyParameters),
        options: Options(
          headers: {'Content-Type': 'application/json;charset=utf-8'},
          responseType: ResponseType.json,
        ),
        onReceiveProgress: (count, total) {},
      );
      final result = response.data['status_code'] as int == 1;
      return result;
    } catch (_) {
      rethrow;
    }
  }
}
