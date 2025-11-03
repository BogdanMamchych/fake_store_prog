import 'package:fake_store_prog/core/local/exceptions.dart';
import 'package:fake_store_prog/core/local/user_preferences.dart';
import 'package:fake_store_prog/core/models/user.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@lazySingleton
class AuthLocalDataSource {
  final UserPreferences _userPreferences;
  final FlutterSecureStorage _secureStorage;

  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';

  AuthLocalDataSource(this._userPreferences, this._secureStorage);

  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: _kAccessToken);
      await _secureStorage.delete(key: _kRefreshToken);
      await _userPreferences.clearUser();
    } catch (e) {
      throw StorageException('Failed to clear local auth data: $e');
    }
  }

  Future<void> saveUser(User user) async {
    try {
      await _userPreferences.setUser(user);
    } catch (e) {
      throw StorageException('Failed to save user: $e');
    }
  }

  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    try {
      await _secureStorage.write(key: _kAccessToken, value: accessToken);
      if (refreshToken != null) {
        await _secureStorage.write(key: _kRefreshToken, value: refreshToken);
      }
    } catch (e) {
      throw StorageException('Failed to save tokens: $e');
    }
  }

  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: _kAccessToken);
    } catch (e) {
      throw StorageException('Failed to read access token: $e');
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _kRefreshToken);
    } catch (e) {
      throw StorageException('Failed to read refresh token: $e');
    }
  }
}
