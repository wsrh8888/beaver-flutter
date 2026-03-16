import 'package:beaver/features/auth/data/repositories/auth_repository.dart';

class RegisterRepository {
  final AuthRepository authRepository;
  
  RegisterRepository({required this.authRepository});
  
  Future<void> register(String email, String password, String confirmPassword) async {
    await authRepository.register(email, password, confirmPassword);
  }
}
