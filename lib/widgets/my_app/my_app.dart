import 'package:flutter/material.dart';
import 'package:the_movie_db/Theme/app_colors.dart';
import 'package:the_movie_db/widgets/my_app/my_app_model.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.model}) : super(key: key);
  final MyAppModel model;
  static final _mainNavigation = MainNavigation();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainDarkBlue,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      routes: _mainNavigation.routes,
      initialRoute: _mainNavigation.setInitialRoute(model.isAuth),
      onGenerateRoute: _mainNavigation.onGenerateRoute,
    );
  }
}
