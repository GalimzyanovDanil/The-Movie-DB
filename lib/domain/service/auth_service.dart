import 'package:the_movie_db/domain/api_client/api_client.dart';
import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';
import 'package:the_movie_db/domain/data_providers/shared_pref_data_provider.dart';

class AuthService {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _sharedPrefDataProvider = SharedPrefDataProvider();

  Future<void> login(String username, String password) async {
    final _sessionId =
        await _apiClient.authRequest(username: username, password: password);
    _sessionDataProvider.setSessionId(_sessionId);
    final _accoutId = await _apiClient.getAccountId(_sessionId);
    _sharedPrefDataProvider.set(_accoutId, SharedPrefKey.accountId);
    return;
  }

  Future<bool> checkAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    return sessionId != null;
  }
}
