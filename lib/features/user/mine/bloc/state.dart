import 'package:beaver/types/business/user.dart';

enum MineStatus { initial, loading, success, error }

class MineState {
  final MineStatus status;
  final UserInfo userInfo;
  final String? errorMessage;

  const MineState({
    this.status = MineStatus.initial,
    this.userInfo = const UserInfo(userId: '', nickname: 'Beaver'),
    this.errorMessage,
  });

  MineState copyWith({
    MineStatus? status,
    UserInfo? userInfo,
    String? errorMessage,
  }) {
    return MineState(
      status: status ?? this.status,
      userInfo: userInfo ?? this.userInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
