import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/domain/data_providers/shared_pref_data_provider.dart';
import 'package:the_movie_db/domain/entity/movie_detail/movie_detail.dart';
import 'package:the_movie_db/widgets/navigation/main_navigation.dart';

class MovieDetailsWidgetModel extends ChangeNotifier {
  final int movieId;
  final _securStorage = SessionDataProvider();
  final _sharedPrefStorage = SharedPrefDataProvider();
  final _apiClient = ApiClient();
  MovieDetail? _movieDetails;
  bool _isFavorite = false;
  String _sessionId = '';
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

  Future<void> markAsFavorite(BuildContext context) async {
    final accountId =
        await _sharedPrefStorage.get<int>(SharedPrefKey.accountId);

    if (accountId == null) return;
    try {
      _isFavorite = await _apiClient.markAsFavorite(
        mediaType: mediaType.movie,
        mediaId: movieId,
        favorite: !_isFavorite,
        sessionId: _sessionId,
        accountId: accountId,
      );
      notifyListeners();
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          // _errorMessage = ErrorMessage.network;
          break;
        case DioErrorType.sendTimeout:
          // _errorMessage = ErrorMessage.network;
          break;
        case DioErrorType.receiveTimeout:
          // _errorMessage = ErrorMessage.network;
          break;
        case DioErrorType.response:
          final _data = e.response?.data as Map<String, dynamic>?;
          final int _statusCode;
          _data != null
              ? _statusCode = _data['status_code'] as int
              : _statusCode = 0;

          if (_statusCode == 3) {
            _securStorage.setSessionId(null);
            _sharedPrefStorage.delete(SharedPrefKey.accountId);
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainNavigationRouteNames.auth, (route) => false);
            // _errorMessage = ErrorMessage.auth;
          } else {
            // _errorMessage = ErrorMessage.other;
          }
          break;
        case DioErrorType.cancel:
          // _errorMessage = ErrorMessage.other;
          break;
        case DioErrorType.other:
          // if (e.error is SocketException) {
          //   _errorMessage = ErrorMessage.network;
          // } else {
          //   _errorMessage = ErrorMessage.other;
          // }
          break;
      }
    } catch (e) {
      // _errorMessage = ErrorMessage.other;
    }
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
    final sessionId = await _securStorage.getSessionId();
    if (sessionId != null) {
      _sessionId = sessionId;
      _isFavorite = await _apiClient.isFavorite(movieId, sessionId);
    }
    notifyListeners();
  }
}
