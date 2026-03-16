import 'package:beaver/features/auth/forget/data/models/reset_password.dart';

abstract class ForgetEvent {
  const ForgetEvent();
}

class SendVerificationCodeEvent extends ForgetEvent {
  final SendVerificationCodeRequest request;

  const SendVerificationCodeEvent(this.request);
}

class ResetPasswordEvent extends ForgetEvent {
  final ResetPasswordRequest request;

  const ResetPasswordEvent(this.request);
}

class UpdateCountdownEvent extends ForgetEvent {
  const UpdateCountdownEvent();
}

class ResetCountdownEvent extends ForgetEvent {
  const ResetCountdownEvent();
}
