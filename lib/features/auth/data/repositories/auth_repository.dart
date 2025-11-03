import 'package:fake_store_prog/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/repositories/i_auth_repository.dart';
import '../../../../core/models/user.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../../../core/local/exceptions.dart';
import 'package:fake_store_prog/core/helpers/jwt_helper.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final AuthRemoteDataSource authRemoteData;
  final AuthLocalDataSource authLocalData;

  AuthRepository({required this.authRemoteData, required this.authLocalData});

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      final rawToken = await _getToken(username, password);
      final token = _normalizeToken(rawToken);
      final id = _getUserIdFromToken(token);
      final userMap = await _fetchUserMapById(id);
      final user = _mapToUser(userMap, id);

      await authLocalData.saveUser(user);
      await authLocalData.saveTokens(accessToken: token);

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
      throw UnexpectedException('Unexpected error during login: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await authLocalData.logout();
    } on StorageException {
      rethrow;
    }
  }

  Future<String> _getToken(String username, String password) async {
    final token = await authRemoteData.login(username, password);

    if (token.trim().isEmpty) {
      throw InvalidCredentialsException(
        'Invalid username or password (empty token)',
      );
    }
    return token;
  }

  String _normalizeToken(String raw) {
    final token = raw.trim();
    if (token.toLowerCase().startsWith('bearer ')) {
      return token.substring(7).trim();
    }
    return token;
  }

  int _getUserIdFromToken(String token) {
    final userIdStr = extractUserIdFromToken(token);

    if (userIdStr == null) {
      throw InvalidCredentialsException('Failed to extract user id from token');
    }

    final id = int.tryParse(userIdStr);
    if (id == null || id <= 0) {
      throw InvalidCredentialsException('Invalid user id in token');
    }

    return id;
  }

  Future<Map<String, dynamic>> _fetchUserMapById(int id) async {
    if (id <= 0) {
      throw UnexpectedException('Invalid user id: $id');
    }

    final resp = await authRemoteData.getUserById(id);

    final data = resp.data;
    if (data == null) throw UnexpectedException('Empty user data');

    if (data is Map<String, dynamic>) {
      if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      if (data.containsKey('result') &&
          data['result'] is Map<String, dynamic>) {
        return data['result'] as Map<String, dynamic>;
      }
      return data;
    }

    if (data is List && data.isNotEmpty && data[0] is Map<String, dynamic>) {
      return data[0] as Map<String, dynamic>;
    }

    throw UnexpectedException('Unexpected user data format');
  }

  User _mapToUser(Map<String, dynamic> userMap, int id) {
    final apiId = userMap['id']?.toString();
    if (apiId != null) {
      final parsed = int.tryParse(apiId);
      if (parsed != null && parsed != id) {}
    }

    final name = (userMap['username'] ?? userMap['name'] ?? '').toString();
    final email = (userMap['email'] ?? '').toString();

    return User(id: id, name: name, email: email);
  }
}
