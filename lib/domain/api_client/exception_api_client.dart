import 'dart:io';

import 'package:dio/dio.dart';

class ExceptionApiClient {
  static const network = 'Ошибка подключения. Проверьте интернет соединение';
  static const sessionExpiered = 'Пожалуйста выполните авторизацию';
  static const auth = 'Неверный логин или пароль!';
  static const other = 'Произошла ошибка. Попробуйте повторить';

  String? handleException(DioError exception) {
    final String exceptionMessage;
    switch (exception.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        exceptionMessage = ExceptionApiClient.network;
        break;
      case DioErrorType.response:
        final _data = exception.response?.data as Map<String, dynamic>?;
        final int _statusCode;
        _data != null
            ? _statusCode = _data['status_code'] as int
            : _statusCode = 0;

        if (_statusCode == 3) {
          exceptionMessage = ExceptionApiClient.sessionExpiered;
        } else {
          exceptionMessage = ExceptionApiClient.other;
        }
        break;
      case DioErrorType.cancel:
        exceptionMessage = ExceptionApiClient.other;
        break;
      case DioErrorType.other:
        if (exception.error is SocketException) {
          exceptionMessage = ExceptionApiClient.network;
        } else {
          exceptionMessage = ExceptionApiClient.other;
        }
        break;
    }
    return exceptionMessage;
  }
}
