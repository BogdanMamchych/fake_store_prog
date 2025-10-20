import 'package:fake_store_prog/core/models/user.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class UserPreferences {
  late SharedPreferences prefs;
  static const _userIdKey = 'userId';
  static const _usernameKey = 'username';
  static const _emailKey = 'email';

  UserPreferences() {
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setUser(User user) async {
    await prefs.setInt(_userIdKey, user.id);
    await prefs.setString(_usernameKey, user.name);
    await prefs.setString(_emailKey, user.email);
  }

  User? getUser() {
    final id = prefs.getInt(_userIdKey);
    final name = prefs.getString(_usernameKey);
    final email = prefs.getString(_emailKey);

    if (id != null && name != null && email != null) {
      return User(id: id, name: name, email: email);
    }
    return null;
  }

  Future<void> clearUser() async {
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
  }
}