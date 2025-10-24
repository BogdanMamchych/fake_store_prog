import 'package:injectable/injectable.dart';

import '../../domain/repositories/i_auth_repository.dart';
import '../../../../core/models/user.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../../../core/local/exceptions.dart';
import 'package:fake_store_prog/core/helpers/jwt_helper.dart';
import 'package:fake_store_prog/core/local/user_preferences.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final AuthRemoteDataSource remote;
  final UserPreferences userPreferences;

  AuthRepository({
    required this.remote,
    required this.userPreferences,
  });

  @override
  Future<User> login({required String username, required String password}) async {
    try {
      final token = await _getToken(username, password);
      final id = _getUserIdFromToken(token);
      final userMap = await _fetchUserMapById(id);
      final user = _mapToUser(userMap, id);
      await _saveUserLocally(user);
      return user;
    } on InvalidCredentialsException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } on StorageException {
      rethrow;
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }


  Future<String> _getToken(String username, String password) async {
    final token = await remote.login(username, password);
    return token;
  }

  int _getUserIdFromToken(String token) {
    final userIdStr = extractUserIdFromToken(token);
    final id = userIdStr != null ? int.tryParse(userIdStr) ?? 0 : 0;
    return id;
  }

  Future<Map<String, dynamic>> _fetchUserMapById(int id) async {
    final resp = await remote.getUserById(id);
    final data = resp.data;
    if (data == null) throw UnexpectedException('Empty user data');
    if (data is Map<String, dynamic>) return data;
    if (data is List && data.isNotEmpty && data[0] is Map<String, dynamic>) {
      return data[0] as Map<String, dynamic>;
    }

    return <String, dynamic>{};
  }

  User _mapToUser(Map<String, dynamic> userMap, int id) {
    return User(
      id: id,
      name: (userMap['username'] ?? userMap['name'] ?? '').toString(),
      email: (userMap['email'] ?? '').toString(),
    );
  }

  Future<void> _saveUserLocally(User user) async {
    try {
      await userPreferences.setUser(user);
    } catch (e) {
      throw StorageException('Failed to save user: $e');
    }
  }
}
