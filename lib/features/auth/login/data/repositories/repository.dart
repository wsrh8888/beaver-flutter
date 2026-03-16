import 'package:beaver/features/auth/data/repositories/auth_repository.dart';

class LoginRepository {
  final AuthRepository authRepository;
  
  LoginRepository({required this.authRepository});
  
  Future<void> login(String email, String password) async {
    await authRepository.login(email, password);
  }
}
