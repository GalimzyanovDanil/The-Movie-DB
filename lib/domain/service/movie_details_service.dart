import 'package:dio/dio.dart';
import 'package:the_movie_db/domain/api_client/account_api_client.dart';
import 'package:the_movie_db/domain/api_client/exception_api_client.dart';
import 'package:the_movie_db/domain/api_client/movie_api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/domain/data_providers/shared_pref_data_provider.dart';
import 'package:the_movie_db/domain/entity/movie_detail/movie_detail.dart';
import 'package:the_movie_db/domain/service/auth_service.dart';

class MovieDetailsService {
  final _movieApiClient = MovieApiClient();
  final _accountApiClient = AccountApiClient();
  final _exceptionApiClient = ExceptionApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _sharedPrefDataProvider = SharedPrefDataProvider();
  final _authService = AuthService();
  String? _exceptionMessage;
  late bool _isFavorite;
  late String _sessionId;

  String? get exceptionMessage => _exceptionMessage;

  Future<MovieDetail?> loadMovieDetails(int movieId, String locale) async {
    try {
      _exceptionMessage = null;
      return await _movieApiClient.movieDetails(movieId, locale);
    } on DioError catch (e) {
      _exceptionMessage = _exceptionApiClient.handleException(e);
    } catch (e) {
      _exceptionMessage = ExceptionApiClient.other;
    }
  }

  Future<bool> getIsFavorite(int movieId) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    bool isFavorite;
    if (sessionId != null) {
      try {
        _exceptionMessage = null;
        isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
      } on DioError catch (e) {
        _exceptionMessage = _exceptionApiClient.handleException(e);
        isFavorite = false;
      } catch (e) {
        _exceptionMessage = ExceptionApiClient.other;
        isFavorite = false;
      }

      _isFavorite = isFavorite;
      _sessionId = sessionId;
    } else {
      isFavorite = false;
    }

    return isFavorite;
  }

  Future<bool?> markAsFavorite(int movieId) async {
    final accountId =
        await _sharedPrefDataProvider.get<int>(SharedPrefKey.accountId);

    if (accountId == null) {
      _exceptionMessage = ExceptionApiClient.sessionExpiered;
      return null;
    }
    
    try {
      _isFavorite = await _accountApiClient.markAsFavorite(
        mediaType: mediaType.movie,
        mediaId: movieId,
        favorite: !_isFavorite,
        sessionId: _sessionId,
        accountId: accountId,
      );
      return _isFavorite;
    } on DioError catch (e) {
      _exceptionMessage = _exceptionApiClient.handleException(e);
      if (_exceptionMessage == ExceptionApiClient.sessionExpiered) {
        _authService.logout();
      }
      return null;
    } catch (e) {
      _exceptionMessage = ExceptionApiClient.other;
      return null;
    }
  }
}
