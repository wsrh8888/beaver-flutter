import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// 登录事件
class AuthLoginEvent extends AuthEvent {
  final String username;
  final String password;

  AuthLoginEvent({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

/// 注册事件
class AuthRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String code;

  AuthRegisterEvent({required this.email, required this.password, required this.code});

  @override
  List<Object?> get props => [email, password, code];
}

/// 获取验证码事件
class AuthGetCodeEvent extends AuthEvent {
  final String email;

  AuthGetCodeEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

/// 退出登录
class AuthLogoutEvent extends AuthEvent {}
