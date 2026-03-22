
import 'package:beaver/types/business/user.dart';

/// 好友仓库接口
abstract class FriendRepositoryInterface {
  Future<List<ContactModel>> getContactList();
  Map<String, List<ContactModel>> groupContactsByLetter(List<ContactModel> contacts);
  List<String> getIndexList(Map<String, List<ContactModel>> groups);
  Future<void> deleteFriend(String friendId);
  Future<UserInfo?> searchUser(String email);
  Future<bool> addFriend(String userId);

  Future<List<FriendRequest>> getFriendRequests();
  Future<bool> updateFriendRequestStatus(int id, int status);
  Future<int> getUnreadFriendRequestCount(String userId);
}

class FriendRequest {
  final int id;
  final String nickname;
  final String fileName;
  final String? message;
  final String source;
  final String flag; // 'receive' or 'send'
  final int status; // 0: pending, 1: accepted, 2: rejected
  final String createdAt;

  const FriendRequest({
    required this.id,
    required this.nickname,
    required this.fileName,
    this.message,
    required this.source,
    required this.flag,
    required this.status,
    required this.createdAt,
  });
}

class ContactModel {
  final String userId;
  final String nickname;
  final String? notice;
  final String? avatar;
  final String? fileName;

  const ContactModel({
    required this.userId,
    required this.nickname,
    this.notice,
    this.avatar,
    this.fileName,
  });

  ContactModel copyWith({
    String? userId,
    String? nickname,
    String? notice,
    String? avatar,
    String? fileName,
  }) {
    return ContactModel(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      notice: notice ?? this.notice,
      avatar: avatar ?? this.avatar,
      fileName: fileName ?? this.fileName,
    );
  }
}
