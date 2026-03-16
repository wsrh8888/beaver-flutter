import 'package:beaver/features/user/config/data/models/config.dart';

enum UserConfigStatus { initial, loading, success, error }

class UserConfigState {
  final UserConfigStatus status;
  final String conversationId;
  final FriendInfo? friendInfo;
  final bool isTopChat;
  final bool showDeleteModal;
  final String? errorMessage;

  const UserConfigState({
    this.status = UserConfigStatus.initial,
    this.conversationId = '',
    this.friendInfo,
    this.isTopChat = false,
    this.showDeleteModal = false,
    this.errorMessage,
  });

  UserConfigState copyWith({
    UserConfigStatus? status,
    String? conversationId,
    FriendInfo? friendInfo,
    bool? isTopChat,
    bool? showDeleteModal,
    String? errorMessage,
  }) {
    return UserConfigState(
      status: status ?? this.status,
      conversationId: conversationId ?? this.conversationId,
      friendInfo: friendInfo ?? this.friendInfo,
      isTopChat: isTopChat ?? this.isTopChat,
      showDeleteModal: showDeleteModal ?? this.showDeleteModal,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

