import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/entity/popular_movies/movie.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final List<Movie> _movies = <Movie>[];
  final _scrollController = ScrollController();
  late DateFormat _dateFormat;
  late String _locale = '';
  // ывапвапвп

  List<Movie> get movies => List.unmodifiable(_movies);
  DateFormat get dateFormat => _dateFormat;
  ScrollController get scrollController => _scrollController;

  void setupLocale(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(_locale);
    _movies.clear();
    _loadPopularMovies();
    return;
  }

  void onTapMovie({required BuildContext context, required int index}) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  Future<void> _loadPopularMovies() async {
    final popularMovies = await _apiClient.popularMovies(1, _locale);
    _movies.addAll(popularMovies.movies);
    notifyListeners();
  }
}
