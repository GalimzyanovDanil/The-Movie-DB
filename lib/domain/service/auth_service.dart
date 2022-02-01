import 'dart:io';
import 'package:dio/dio.dart';
import 'package:the_movie_db/domain/api_client/account_api_client.dart';
import 'package:the_movie_db/domain/api_client/auth_api_client.dart';
import 'package:the_movie_db/domain/api_client/exception_api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/domain/data_providers/shared_pref_data_provider.dart';

class AuthService {
  final _authApiClient = AuthApiClient();
  final _accountApiClient = AccountApiClient();

  final _sessionDataProvider = SessionDataProvider();
  final _sharedPrefDataProvider = SharedPrefDataProvider();

  Future<String?> login(String username, String password) async {
    final String _sessionId;
    String? _errorMessage;
    try {
      _sessionId = await _authApiClient.authRequest(
          username: username, password: password);
      _sessionDataProvider.setSessionId(_sessionId);
      final _accoutId = await _accountApiClient.getAccountId(_sessionId);
      _sharedPrefDataProvider.set(_accoutId, SharedPrefKey.accountId);
      _errorMessage = null;
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          _errorMessage = ExceptionApiClient.network;
          break;
        case DioErrorType.sendTimeout:
          _errorMessage = ExceptionApiClient.network;
          break;
        case DioErrorType.receiveTimeout:
          _errorMessage = ExceptionApiClient.network;
          break;
        case DioErrorType.response:
          final _data = e.response?.data as Map<String, dynamic>?;
          final int _statusCode;
          _data != null
              ? _statusCode = _data['status_code'] as int
              : _statusCode = 0;

          if (_statusCode == 30 || _statusCode == 32) {
            _errorMessage = ExceptionApiClient.auth;
          } else {
            _errorMessage = ExceptionApiClient.other;
          }
          break;
        case DioErrorType.cancel:
          _errorMessage = ExceptionApiClient.other;
          break;
        case DioErrorType.other:
          if (e.error is SocketException) {
            _errorMessage = ExceptionApiClient.network;
          } else {
            _errorMessage = ExceptionApiClient.other;
          }
          break;
      }
    } catch (e) {
      _errorMessage = ExceptionApiClient.other;
    }
    return _errorMessage;
  }

  Future<bool> checkAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    return sessionId != null;
  }
}
