import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/group/member/bloc/bloc.dart';
import 'package:beaver/features/group/member/bloc/event.dart';
import 'package:beaver/features/group/member/bloc/state.dart';
import 'package:beaver/features/group/member/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';

class GroupMemberPage extends StatefulWidget {
  const GroupMemberPage({super.key});

  @override
  State<GroupMemberPage> createState() => _GroupMemberPageState();
}

class _GroupMemberPageState extends State<GroupMemberPage> {
  late GroupMemberBloc _groupMemberBloc;

  @override
  void initState() {
    super.initState();
    _groupMemberBloc = GroupMemberBloc(GroupMemberRepository());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 假设从路由参数获�?groupId �?mode
      _groupMemberBloc.add(LoadGroupMembersEvent('123', 'view'));
    });
  }

  @override
  void dispose() {
    _groupMemberBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _toggleSelect(String userId) {
    _groupMemberBloc.add(ToggleSelectEvent(userId));
  }

  void _confirmAdd() {
    _groupMemberBloc.add(ConfirmAddEvent());
  }

  void _confirmRemove() {
    _groupMemberBloc.add(ConfirmRemoveEvent());
  }

  String _getPageTitle() {
    switch (_groupMemberBloc.state.mode) {
      case 'add':
        return '添加成员';
      case 'remove':
        return '移除成员';
      default:
        return '群成�?;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _groupMemberBloc,
      child: BlocConsumer<GroupMemberBloc, GroupMemberState>(
        listener: (context, state) {
          if (state.status == GroupMemberStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          } else if (state.status == GroupMemberStatus.success && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final groupOwner = state.groupMembers.firstWhere(
            (member) => member.role == 2,
            orElse: () => GroupMember(
              userId: '1',
              nickname: '群主',
              fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20owner&size=512x512',
              role: 2,
            ),
          );

          final members = state.groupMembers.where((member) => member.role != 2).toList();

          return BeaverLayout(
            title: _getPageTitle(),
            showBack: true,
            showBackground: true,
            backgroundType: 'gradient',
            backgroundHeight: 120.w,
            isScrollable: true,
            child: Column(
              children: [
                // 查看模式
                if (state.mode == 'view') ...[
                  // 群主
                  _buildSectionTitle('群主'),
                  _buildMemberItem(groupOwner, false),
                  // 成员
                  _buildSectionTitle('成员'),
                  ...members.map((member) => _buildMemberItem(member, false)),
                ],
                // 添加模式
                if (state.mode == 'add') ...[
                  if (state.contacts.isEmpty)
                    _buildEmptyState('没有可添加的联系�?, '你的所有联系人已经在群里了')
                  else
                    ...state.contacts.map((contact) => _buildContactItem(contact, 'add')),
                ],
                // 移除模式
                if (state.mode == 'remove') ...[
                  // 群主
                  _buildSectionTitle('群主'),
                  _buildMemberItem(groupOwner, false),
                  // 成员
                  _buildSectionTitle('成员'),
                  ...members.map((member) => _buildMemberItem(member, true)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.w,
          color: const Color(0xFF636E72),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMemberItem(member, bool showAction) {
    final isSelected = _groupMemberBloc.state.selectedIds.contains(member.userId);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFEBEEF5),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          BeaverAvatar(
            url: member.fileName,
            size: 48.w,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.nickname,
                  style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                if (member.role == 1)
                  Text(
                    '管理�?,
                    style: TextStyle(
                      fontSize: 12.w,
                      color: const Color(0xFFFF7D45),
                    ),
                  ),
              ],
            ),
          ),
          if (showAction)
            GestureDetector(
              onTap: () => _toggleSelect(member.userId),
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFF7D45)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(12.w),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFF7D45)
                        : Colors.transparent,
                    width: 2.w,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.check,
                  size: 16.w,
                  color: isSelected ? Colors.white : Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactItem(contact, String actionType) {
    final isSelected = _groupMemberBloc.state.selectedIds.contains(contact.userId);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFEBEEF5),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        children: [
          BeaverAvatar(
            url: contact.fileName,
            size: 48.w,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              contact.nickname,
              style: TextStyle(
                fontSize: 16.w,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _toggleSelect(contact.userId),
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF7D45)
                    : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(12.w),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF7D45)
                      : Colors.transparent,
                  width: 2.w,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.check,
                size: 16.w,
                color: isSelected ? Colors.white : Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String description) {
    return Container(
      padding: EdgeInsets.all(48.w),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.inbox,
            size: 80.w,
            color: const Color(0xFFE0E0E0),
          ),
          SizedBox(height: 24.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.w,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.w,
              color: const Color(0xFFB2BEC3),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

