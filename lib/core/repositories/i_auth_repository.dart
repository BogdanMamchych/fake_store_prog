abstract class IAuthRepository {

  Future<void> login({
    required String username,
    required String password,
  });

  Future<void> logout();
}