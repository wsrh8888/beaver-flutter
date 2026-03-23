abstract class RegisterEvent {} 

class RegisterSubmitEvent extends RegisterEvent {
  final String email;
  final String password;
  final String confirmPassword;
  
  RegisterSubmitEvent({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}
