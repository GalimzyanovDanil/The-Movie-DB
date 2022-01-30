import 'package:flutter/material.dart';
import 'package:the_movie_db/domain/factories/screen_factories.dart';


abstract class MainNavigationRouteNames {
  static const loader = '/';
  static const auth = '/auth';
  static const main = '/main';
  static const movieDetails = '/main/movie_details';
  static const movieTrailer = '/main/movie_details/trailer';
}

class MainNavigation {
  static final _screenFactories = ScreenFactories();

  final Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    MainNavigationRouteNames.main: (context) => _screenFactories.createMain(),
  };

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = (arguments != null && arguments is int) ? arguments : 0;
        return MaterialPageRoute(
          builder: (context) => _screenFactories.createMovieDetails(movieId),
        );

      case MainNavigationRouteNames.movieTrailer:
        final arguments = settings.arguments;
        final key = (arguments != null && arguments is String) ? arguments : '';
        return MaterialPageRoute(
          builder: (context) => _screenFactories.createMovieTrailer(key),
        );

      case MainNavigationRouteNames.loader:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => _screenFactories.createLoader(),
        );

      case MainNavigationRouteNames.auth:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => _screenFactories.createAuth(),
          // transitionsBuilder: (c, anim, a2, child) =>
          //     FadeTransition(opacity: anim, child: child),
          // transitionDuration: Duration(seconds: 6),
          // reverseTransitionDuration: Duration(seconds: 3),
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
