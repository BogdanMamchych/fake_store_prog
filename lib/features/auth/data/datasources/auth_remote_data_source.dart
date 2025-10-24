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

      final data = resp.data;
      if (data == null) {
        throw UnexpectedException('Empty response from server');
      }

      String? token;
      if (data is Map) {
        token = data['token']?.toString() ?? data['accessToken']?.toString() ?? data['access_token']?.toString();
      } else if (data is String) {
        token = data;
      } else {
        token = data.toString();
      }

      if (token == null || token.isEmpty) {
        final possible = (data is Map) ? (data['data'] ?? data['result'] ?? data['message']) : null;
        if (possible is String && possible.isNotEmpty) token = possible;
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
        // network error
        throw NetworkException(dioErr.message ?? 'Network error');
      }
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  Future<Response> getUserById(int id) async {
    try {
      return await _apiClient.getUserById(id);
    } on DioException catch (dioErr) {
      if (dioErr.response != null) {
        final resp = dioErr.response!;
        throw ServerException(resp.statusCode, resp.statusMessage ?? 'Server error');
      } else {
        throw NetworkException(dioErr.message ?? 'Network error');
      }
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

}
