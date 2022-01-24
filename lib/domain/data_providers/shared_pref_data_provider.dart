import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefKey {
  static const String accountId = 'account-id';
}

class SharedPrefDataProvider {
  final Future<SharedPreferences> _storage = SharedPreferences.getInstance();

  Future<void> set<T>(T? data, String key) async {
    if (data is bool) (await _storage).setBool(key, data);
    if (data is double) (await _storage).setDouble(key, data);
    if (data is int) (await _storage).setInt(key, data);
    if (data is String) (await _storage).setString(key, data);
    return;
  }

  Future<T?> get<T>(String key) async {
    return (await _storage).get(key) as T;
  }
}
