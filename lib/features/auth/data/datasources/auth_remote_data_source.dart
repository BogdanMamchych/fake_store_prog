import 'package:dio/dio.dart';
import 'package:fake_store_prog/core/api/api_client.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/local/exceptions.dart';

@lazySingleton
class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<String> login(String username, String password) async {
    try {
      final Response resp = await _apiClient.login(username, password);

      final status = resp.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        throw ServerException(status, resp.statusMessage ?? 'Login failed');
      }

      final data = resp.data;
      if (data == null) {
        throw UnexpectedException('Empty response from server');
      }

      String? token;
      if (data is Map) {
        token = (data['token'] ?? data['accessToken'] ?? data['access_token'])?.toString();
      } else if (data is String) {
        token = data;
      }

      if ((token == null || token.isEmpty) && data is Map) {
        final possible = data['data'] ?? data['result'] ?? data['message'];
        if (possible is String && possible.isNotEmpty) {
          token = possible;
        }
      }

      if (token == null || token.isEmpty) {
        throw UnexpectedException('No token in response');
      }

      return token;
    } on DioException catch (dioErr) {
      if (dioErr.response != null) {
        final resp = dioErr.response!;
        if (resp.statusCode == 401 || resp.statusCode == 403) {
          throw InvalidCredentialsException('Invalid username or password');
        } else {
          throw ServerException(resp.statusCode, resp.statusMessage ?? 'Server error');
        }
      } else {
        throw NetworkException(dioErr.message ?? 'Network error');
      }
    } catch (e) {
      throw UnexpectedException('AuthRemoteDataSource.login unexpected: $e');
    }
  }

  Future<Response> getUserById(int id) async {
    try {
      final Response resp = await _apiClient.getUserById(id);

      final status = resp.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        throw ServerException(status, resp.statusMessage ?? 'Failed to fetch user');
      }

      return resp;
    } on DioException catch (dioErr) {
      if (dioErr.response != null) {
        final resp = dioErr.response!;
        throw ServerException(resp.statusCode, resp.statusMessage ?? 'Server error');
      } else {
        throw NetworkException(dioErr.message ?? 'Network error');
      }
    } catch (e) {
      throw UnexpectedException('AuthRemoteDataSource.getUserById unexpected: $e');
    }
  }
}
