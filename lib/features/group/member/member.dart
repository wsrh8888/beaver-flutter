import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/index.dart';

class GroupMember {
  final String userId;
  final String nickname;
  final String? avatar;
  final String role;

  GroupMember({
    required this.userId,
    required this.nickname,
    this.avatar,
    required this.role,
  });
}

class GroupMemberPage extends StatefulWidget {
  final String groupId;
  const GroupMemberPage({super.key, required this.groupId});

  @override
  State<GroupMemberPage> createState() => _GroupMemberPageState();
}

class _GroupMemberPageState extends State<GroupMemberPage> {
  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '群成员',
      showBack: true,
      child: ListView.builder(
        itemCount: 1, // 模拟
        itemBuilder: (context, index) {
          return _buildMemberItem(
            GroupMember(
              userId: '1',
              nickname: '管理员',
              role: 'owner',
            ),
          );
        },
      ),
    );
  }

  Widget _buildMemberItem(GroupMember member) {
    return ListTile(
      leading: BeaverAvatar(
        url: member.avatar ?? '',
        nickname: member.nickname,
        size: 40.w,
      ),
      title: Text(member.nickname),
      trailing: Text(
        member.role == 'owner' ? '群主' : '成员',
        style: TextStyle(fontSize: 12.w, color: Colors.grey),
      ),
    );
  }
}
