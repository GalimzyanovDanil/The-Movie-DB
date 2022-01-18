import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

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
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          _errorMessage = _ErrorMessage.network;
          break;
        case DioErrorType.sendTimeout:
          _errorMessage = _ErrorMessage.network;
          break;
        case DioErrorType.receiveTimeout:
          _errorMessage = _ErrorMessage.network;
          break;
        case DioErrorType.response:
          final _data = e.response?.data as Map<String, dynamic>?;
          final int _statusCode;
          _data != null
              ? _statusCode = _data['status_code'] as int
              : _statusCode = 0;

          if (_statusCode == 30 || _statusCode == 32) {
            _errorMessage = _ErrorMessage.auth;
          } else {
            _errorMessage = _ErrorMessage.other;
          }
          break;
        case DioErrorType.cancel:
          _errorMessage = _ErrorMessage.other;
          break;
        case DioErrorType.other:
          if (e.error is SocketException) {
            _errorMessage = _ErrorMessage.network;
          } else {
            _errorMessage = _ErrorMessage.other;
          }
          break;
      }
    } catch (e) {
      _errorMessage = _ErrorMessage.other;
    }
    _isAuthActive = false;

    if (_sessionId == null || _errorMessage != null) {
      return false;
    }

    await _sessionDataProvider.setSessionId(_sessionId);
    return true;
  }
}

class _ErrorMessage {
  static const network = 'Ошибка подключения. Проверьте интернет соединение';
  static const auth = 'Неверный логин или пароль!';
  static const other = 'Произошла ошибка. Попробуйте повторить';
}

/*
30 - password or email error
32 - email not veryfied

*/
