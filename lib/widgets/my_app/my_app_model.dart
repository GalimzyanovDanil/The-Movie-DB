import 'package:the_movie_db/domain/data_providers/session_data_provider.dart';

class MyAppModel {
  final sessionData = SessionDataProvider();
  bool isAuth = false;

  Future<void> checkAuth() async {
    final sessionId = await sessionData.getSessionId();
    if (sessionId == null) {
      isAuth = false;
    } else {
      isAuth = true;
    }
    return;
  }
}
