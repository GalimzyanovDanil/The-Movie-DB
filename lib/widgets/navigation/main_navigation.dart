import 'package:flutter/material.dart';
import 'package:the_movie_db/library/widgets/inherited/provider.dart';
import 'package:the_movie_db/widgets/auth/auth_widget.dart';
import 'package:the_movie_db/widgets/auth/auth_widget_model.dart';
import 'package:the_movie_db/widgets/main_screen/main_screen_model.dart';
import 'package:the_movie_db/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_db/widgets/movie_details/movie_details_model.dart';
import 'package:the_movie_db/widgets/movie_details/movie_details_widget.dart';
import 'package:the_movie_db/widgets/movie_trailer/movie_trailer_model.dart';
import 'package:the_movie_db/widgets/movie_trailer/movie_trailer_widget.dart';

abstract class MainNavigationRouteNames {
  static const auth = 'auth';
  static const main = '/';
  static const movieDetails = '/movie_details';
  static const movieTrailer = '/movie_details/trailer';
}

class MainNavigation {
  final Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    MainNavigationRouteNames.auth: (context) => NotifierProvider(
          create: () => AuthModel(),
          child: const AuthWidget(),
        ),
    MainNavigationRouteNames.main: (context) => NotifierProvider(
          create: () => MainScreenModel(),
          child: const MainScreenWidget(),
        ),
  };

  String setInitialRoute(bool isAuth) {
    return isAuth
        ? MainNavigationRouteNames.main
        : MainNavigationRouteNames.auth;
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = (arguments != null && arguments is int) ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
            create: () => MovieDetailsModel(movieId),
            child: const MovieDetailsWidget(),
          ),
        );

      case MainNavigationRouteNames.movieTrailer:
        final arguments = settings.arguments;
        final key = (arguments != null && arguments is String) ? arguments : '';
        return MaterialPageRoute(
          builder: (context) => NotifierProvider(
            create: () => MovieTrailerModel(key),
            child: const MovieTrailerWidget(),
          ),
        );

      default:
        MaterialPageRoute(
          builder: (context) => const Center(
            child: Text('Navigation error!'),
          ),
        );
    }
  }
}
