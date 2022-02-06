import 'package:flutter/material.dart';
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
      (validAuth)
          ? Navigator.of(context)
              .pushReplacementNamed(MainNavigationRouteNames.main)
          : notifyListeners();
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
    _errorMessage = await _authService.login(username, password);
    _isAuthActive = false;
    return _errorMessage == null;
  }
}


/*
30 - password or email error
32 - email not veryfied

*/
