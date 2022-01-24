import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/entity/movie_detail/movie_detail.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class MovieDetailsModel extends ChangeNotifier {
  final int movieId;
  final _apiClient = ApiClient();
  MovieDetail? _movieDetails;
  late DateFormat _dateFormat;

  late String _locale = '';

  MovieDetail? get movieDetails => _movieDetails;
  DateFormat get dateFormat => _dateFormat;

  MovieDetailsModel(this.movieId);

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
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    notifyListeners();
  }
}
