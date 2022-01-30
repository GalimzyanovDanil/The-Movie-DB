import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/widgets/auth/auth_widget.dart';
import 'package:the_movie_db/widgets/auth/auth_widget_model.dart';
import 'package:the_movie_db/widgets/loader/loader_widget.dart';
import 'package:the_movie_db/widgets/loader/loader_widget_model.dart';
import 'package:the_movie_db/widgets/main_screen/main_screen_model.dart';
import 'package:the_movie_db/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_db/widgets/movie_details/movie_details_model.dart';
import 'package:the_movie_db/widgets/movie_details/movie_details_widget.dart';
import 'package:the_movie_db/widgets/movie_trailer/movie_trailer_model.dart';
import 'package:the_movie_db/widgets/movie_trailer/movie_trailer_widget.dart';

class ScreenFactories {
  Widget createLoader() {
    return Provider<LoaderWidgetModel>(
      create: (context) => LoaderWidgetModel(context),
      child: const LoaderWidget(),
      lazy: false,
    );
  }

  Widget createMain() {
    return ChangeNotifierProvider<MainScreenWidgetModel>(
      create: (context) => MainScreenWidgetModel(),
      child: const MainScreenWidget(),
    );
  }

  Widget createMovieDetails(int movieId) {
    return ChangeNotifierProvider<MovieDetailsWidgetModel>(
      create: (context) => MovieDetailsWidgetModel(movieId),
      child: const MovieDetailsWidget(),
    );
  }

  Widget createMovieTrailer(String key) {
    return ChangeNotifierProvider<MovieTrailerWidgetModel>(
      create: (context) => MovieTrailerWidgetModel(key),
      child: const MovieTrailerWidget(),
    );
  }

  Widget createAuth() {
    return ChangeNotifierProvider<AuthWidgetModel>(
      create: (context) => AuthWidgetModel(),
      child: const AuthWidget(),
    );
  }

 

  
}
