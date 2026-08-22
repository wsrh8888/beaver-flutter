import 'package:beaver/features/common/select_friend/select_friend_page.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:flutter/material.dart';

/// 打开选择好友页，返回选中的好友列表；取消返回 null
Future<List<ContactModel>?> openSelectFriend(
  BuildContext context, {
  String title = '选择好友',
  List<ContactModel> initialSelected = const [],
  List<String> disabledUserIds = const [],
}) {
  return Navigator.of(context).push<List<ContactModel>>(
    MaterialPageRoute(
      builder: (_) => SelectFriendPage(
        title: title,
        initialSelected: initialSelected,
        disabledUserIds: disabledUserIds,
      ),
    ),
  );
}
