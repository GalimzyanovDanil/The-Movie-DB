import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/domain/data_providers/shared_pref_data_provider.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _sharedPrefDataProvider = SharedPrefDataProvider();

  String? get errorMessage => _errorMessage;
  bool get canLogin => !_isAuthActive;

  String? _errorMessage;
  bool _isAuthActive = false;

  void auth(BuildContext context) {
    _auth().then((validAuth) {
      if (validAuth) {
        return Navigator.of(context)
            .pushReplacementNamed(MainNavigationRouteNames.main);
      }
      notifyListeners();
    });
  }

  void resetPassword() {
    loginTextController.text = 'danil_galimzyanov';
    passwordTextController.text = 'Pnivvjka7*';
  }

  Future<bool> _auth() async {
    final username = loginTextController.text;
    final password = passwordTextController.text;
    String? _sessionId;
    int? _accoutId;

    if (username.isEmpty || password.isEmpty) {
      _errorMessage = 'Заполните логин и пароль';
      return false;
    }

    _errorMessage = null;
    _isAuthActive = true;
    notifyListeners();

    try {
      _sessionId =
          await _apiClient.authRequest(username: username, password: password);
      _accoutId = await _apiClient.getAccountId(_sessionId);
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
          final _data = e.response?.data as Map<String, dynamic>?;
          final int _statusCode;
          _data != null
              ? _statusCode = _data['status_code'] as int
              : _statusCode = 0;

          if (_statusCode == 30 || _statusCode == 32) {
            _errorMessage = ErrorMessage.auth;
          } else {
            _errorMessage = ErrorMessage.other;
          }
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
    } catch (e) {
      _errorMessage = ErrorMessage.other;
    }
    _isAuthActive = false;

    if (_sessionId == null || _errorMessage != null) {
      return false;
    }

    await _sessionDataProvider.setSessionId(_sessionId);
    await _sharedPrefDataProvider.set<int>(_accoutId, SharedPrefKey.accountId);
    return true;
  }
}

/*
30 - password or email error
32 - email not veryfied

*/
