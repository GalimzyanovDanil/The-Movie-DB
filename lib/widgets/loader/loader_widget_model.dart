import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/service/auth_service.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class LoaderWidgetModel {
  final authService = AuthService();
  final BuildContext context;

  LoaderWidgetModel(this.context) {
    init();
  }

  void init() {
    authService.checkAuth().then((isAuth) {
      final nextScreen = (isAuth)
          ? MainNavigationRouteNames.main
          : MainNavigationRouteNames.auth;
      Navigator.of(context).pushReplacementNamed(nextScreen);
    });
  }
}
