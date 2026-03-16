import 'package:beaver/features/detail/detail_page/data/models/user_info.dart';

enum DetailStatus { initial, loading, success, error }

class DetailState {
  final DetailStatus status;
  final UserInfo? userInfo;
  final bool isFriend;
  final String? newRemarkName;
  final bool showEditNoteDialog;
  final bool showMoreMenu;
  final String? errorMessage;

  const DetailState({
    this.status = DetailStatus.initial,
    this.userInfo,
    this.isFriend = false,
    this.newRemarkName,
    this.showEditNoteDialog = false,
    this.showMoreMenu = false,
    this.errorMessage,
  });

  DetailState copyWith({
    DetailStatus? status,
    UserInfo? userInfo,
    bool? isFriend,
    String? newRemarkName,
    bool? showEditNoteDialog,
    bool? showMoreMenu,
    String? errorMessage,
  }) {
    return DetailState(
      status: status ?? this.status,
      userInfo: userInfo ?? this.userInfo,
      isFriend: isFriend ?? this.isFriend,
      newRemarkName: newRemarkName ?? this.newRemarkName,
      showEditNoteDialog: showEditNoteDialog ?? this.showEditNoteDialog,
      showMoreMenu: showMoreMenu ?? this.showMoreMenu,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
