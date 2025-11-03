import 'package:fake_store_prog/core/repositories/i_auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final IAuthRepository repository;
  LoginUseCase(this.repository);

  Future<void> call({
    required String username,
    required String password,
  }) async {
    await repository.login(username: username, password: password);  }
}
