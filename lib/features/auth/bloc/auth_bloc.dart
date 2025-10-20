import 'package:fake_store_prog/core/helpers/jwt_helper.dart';
import 'package:fake_store_prog/core/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import 'package:fake_store_prog/core/api/api_client.dart';
import 'package:fake_store_prog/core/local/token_storage.dart';
import 'package:fake_store_prog/core/local/user_preferences.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;
  final UserPreferences _userPreferences;

  AuthBloc({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
    required UserPreferences userPreferences,
  })  : _apiClient = apiClient,
        _tokenStorage = tokenStorage,
        _userPreferences = userPreferences,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final Response response =
          await _apiClient.login(event.username, event.password);

      final dynamic data = response.data;

      String? token;

      if (data == null) {
        throw Exception('Empty response from server');
      }

      if (data is Map) {
        token = data['token']?.toString() ?? data['accessToken']?.toString();
      } else if (data is String) {
        token = data;
      } else {
        token = data.toString();
      }

      if (token == null || token.isEmpty) {
        final possible =
            (data is Map) ? (data['data'] ?? data['result'] ?? data['message']) : null;
        if (possible is String && possible.isNotEmpty) {
          token = possible;
        }
      }

      if (token == null || token.isEmpty) {
        emit(const AuthError(message: 'No token returned from server'));
        return;
      }

      await _tokenStorage.setToken(token);
      final userID = extractUserIdFromToken(token);
      int id = userID != null ? int.tryParse(userID) ?? 0 : 0;
      final userData = await _apiClient.getUserById(id);
      final user = User.fromJson(userData.data);
      await _userPreferences.setUser(user);

      emit(AuthAuthenticated(token: token));
    } on DioException catch (dioErr) {
      String message = 'Network error';
      if (dioErr.response != null) {
        final resp = dioErr.response!;
        try {
          final d = resp.data;
          if (d is Map && d['message'] != null) {
            message = d['message'].toString();
          } else if (resp.statusMessage != null) {
            message = resp.statusMessage!;
          } else {
            message = 'Request failed: ${resp.statusCode}';
          }
        } catch (_) {
          message = 'Request failed: ${resp.statusCode}';
        }
      } else if (dioErr.message != null) {
        message = dioErr.message!;
      }
      emit(AuthError(message: message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
