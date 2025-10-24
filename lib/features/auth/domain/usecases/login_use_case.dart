import 'package:fake_store_prog/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final IAuthRepository repository;
  LoginUseCase(this.repository);

  Future<void> call({
    required String username,
    required String password,
  }) async {
    repository.login(username: username, password: password);  }
}
