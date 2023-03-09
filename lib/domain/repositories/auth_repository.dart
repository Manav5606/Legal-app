abstract class AuthRepository {
  Future create({
    required String email,
    required String password,
    required String name,
  });
}
