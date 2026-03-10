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
  final String username;
  final String password;

  AuthRegisterEvent({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

/// 退出登录
class AuthLogoutEvent extends AuthEvent {}
