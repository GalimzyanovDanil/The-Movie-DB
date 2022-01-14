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
    } catch (e) {
      _errorMessage = 'Неправильный логин или пароль!';
    }
    _isAuthActive = false;

    if (_sessionId == null || _errorMessage != null) {
      return false;
    }

    await _sessionDataProvider.setSessionId(_sessionId);
    return true;
  }
}

