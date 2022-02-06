import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/entity/movie_detail/movie_detail.dart';
import 'package:the_movie_db/domain/service/movie_details_service.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class MovieDetailsWidgetModel extends ChangeNotifier {
  final _movieDetailsService = MovieDetailsService();

  final int movieId;
  MovieDetail? _movieDetails;
  bool _isFavorite = false;

  late DateFormat _dateFormat;

  late String _locale = '';

  MovieDetail? get movieDetails => _movieDetails;
  DateFormat get dateFormat => _dateFormat;
  bool get isFavorite => _isFavorite;

  MovieDetailsWidgetModel(this.movieId);

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(_locale);

    await _loadMovieDetails();
    return;
  }

  Future<void> onTapTrailer(
      {required BuildContext context, required String key}) async {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieTrailer,
      arguments: key,
    );
  }

  String releaseDateToString(DateTime? releaseDate) {
    final date = releaseDate != null ? dateFormat.format(releaseDate) : '';
    return date;
  }

  Future<void> _loadMovieDetails() async {
    _movieDetails =
        await _movieDetailsService.loadMovieDetails(movieId, _locale);
    _isFavorite = await _movieDetailsService.getIsFavorite(movieId);
    notifyListeners();
  }

  Future<void> markAsFavorite(BuildContext context) async {
    final bool? isFavorite = await _movieDetailsService.markAsFavorite(movieId);
    if (isFavorite != null) {
      _isFavorite = isFavorite;
      notifyListeners();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          MainNavigationRouteNames.loader, (route) => false);
    }
  }
}
