

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const String sessionIdKey = 'session-id';
}

class SessionDataProvider {
  final _storage = const FlutterSecureStorage();

  Future<void> setSessionId(String? sessionId) {
    if (sessionId == null) return _storage.delete(key: _Keys.sessionIdKey);
    
    return _storage.write(key: _Keys.sessionIdKey, value: sessionId);
  }

  Future<String?> getSessionId() {
    return _storage.read(key: _Keys.sessionIdKey);
  }
}
