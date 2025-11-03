import 'package:fake_store_prog/core/repositories/i_auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogOutUseCase {
  final IAuthRepository authRepository;

  LogOutUseCase({required this.authRepository});

  Future<void> call () async {
    await authRepository.logout();
  }
}