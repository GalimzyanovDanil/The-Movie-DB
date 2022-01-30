import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/service/auth_service.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class AuthWidgetModel extends ChangeNotifier {
  final _authService = AuthService();

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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

    if (username.isEmpty || password.isEmpty) {
      _errorMessage = 'Заполните логин и пароль';
      return false;
    }

    _errorMessage = null;
    _isAuthActive = true;
    notifyListeners();

    try {
      _authService.login(username, password);
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

    return _errorMessage == null;
  }
}

/*
30 - password or email error
32 - email not veryfied

*/
