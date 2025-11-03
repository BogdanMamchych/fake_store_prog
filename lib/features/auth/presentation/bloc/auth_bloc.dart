import 'package:fake_store_prog/core/local/exceptions.dart';
import 'package:fake_store_prog/core/usecases/log_out_use_case.dart';
import 'package:fake_store_prog/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogOutUseCase _logOutUseCase;

  AuthBloc({
    required LogOutUseCase logOutUseCase,
    required LoginUseCase loginUseCase,
  }) : _loginUseCase = loginUseCase,
       _logOutUseCase = logOutUseCase,
       super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogOutRequested>(_onLogOutEvent);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _loginUseCase(username: event.username, password: event.password);
      emit(AuthAuthenticated());
    } on InvalidCredentialsException catch (e) {
      emit(AuthError(message: e.message));
    } on NetworkException catch (e) {
      emit(AuthError(message: 'Network exception: ${e.message}'));
    } on ServerException catch (e) {
      emit(AuthError(message: 'Server exception: ${e.message}'));
    } on StorageException catch (e) {
      emit(AuthError(message: 'Storage exception: ${e.message}'));
    } on UnexpectedException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogOutEvent(
    LogOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      _logOutUseCase;
    } on StorageException catch (e) {
      emit(AuthError(message: 'Storage exception: ${e.message}'));
    }
  }
}
