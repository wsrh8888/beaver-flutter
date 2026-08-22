import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/types/business/group.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupSettingPanel extends StatelessWidget {
  final String title;
  final String groupId;
  final int memberCount;
  final String avatar;
  final bool isTop;
  final bool isMuted;
  final List<GroupMember> members;
  final bool isAdmin;
  final bool isGroupOwner;
  final ContactStore contactStore; // 新增：全局联系人仓库
  final VoidCallback onToggleTop;
  final VoidCallback onToggleMute;
  final VoidCallback onClearHistory;
  final VoidCallback onDeleteConversation;
  final VoidCallback onAddMember;
  final VoidCallback? onShare;
  final Function(String userId) onRemoveMember;

  const GroupSettingPanel({
    super.key,
    required this.title,
    required this.groupId,
    required this.memberCount,
    required this.avatar,
    required this.isTop,
    required this.isMuted,
    required this.members,
    required this.isAdmin,
    required this.isGroupOwner,
    required this.contactStore,
    required this.onToggleTop,
    required this.onToggleMute,
    required this.onClearHistory,
    required this.onDeleteConversation,
    required this.onAddMember,
    this.onShare,
    required this.onRemoveMember,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildMembersSection(),
        SizedBox(height: 12.w),
        _buildActionList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        children: [
          BeaverCachedImage(
            fileUrl: avatar,
            type: CacheType.avatar,
            width: 52.w,
            height: 52.w,
            borderRadius: 12.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                SizedBox(height: 4.w),
                Text(
                  '群ID: $groupId  ·  ${members.length}人',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF636E72),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMembersSection() {
    // Show top members
    final displayMembers = members.take(isAdmin ? 19 : 20).toList();
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '群成员',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3436),
                ),
              ),
              if (members.length > 20)
                Icon(Icons.arrow_forward_ios, size: 14.sp, color: const Color(0xFFB2BEC3)),
            ],
          ),
          SizedBox(height: 16.w),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 12.w,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.8,
            ),
            itemCount: displayMembers.length + (isAdmin ? 1 : 0),
            itemBuilder: (context, index) {
              if (isAdmin && index == displayMembers.length) {
                return _buildAddButton();
              }
              
              final member = displayMembers[index];
              return _buildMemberItem(context, member);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMemberItem(BuildContext context, GroupMember member) {
    // 从 ContactStore 获取最新的用户头像和昵称 (对标 PC 响应式逻辑)
    final contactInfo = contactStore.getContact(member.userId);
    final displayAvatar = contactInfo?.avatar ?? member.avatar ?? '';
    final displayNickname = contactInfo?.nickname ?? member.nickname ?? member.userId.substring(0, 4);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            BeaverCachedImage(
              fileUrl: displayAvatar,
              type: CacheType.avatar,
              width: 44.w,
              height: 44.w,
              borderRadius: 8.w,
            ),
            if (isAdmin && member.role != 1) // Owner cannot be removed
              Positioned(
                top: -4.w,
                right: -4.w,
                child: GestureDetector(
                  onTap: () => _showRemoveConfirm(context, member),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5252),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 10.w, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 4.w),
        Text(
          displayNickname,
          style: TextStyle(fontSize: 11.sp, color: const Color(0xFF636E72)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _showRemoveConfirm(BuildContext context, GroupMember member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('移除成员'),
        content: Text('确定要将 ${member.nickname ?? member.userId} 移出群聊吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRemoveMember(member.userId);
            },
            child: const Text('移除', style: TextStyle(color: Color(0xFFFF5252))),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddMember,
      child: Column(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8.w),
              border: Border.all(color: const Color(0xFFEBEEF5)),
            ),
            child: Icon(Icons.add, color: const Color(0xFFB2BEC3), size: 24.w),
          ),
          SizedBox(height: 4.w),
          Text(
            '邀请',
            style: TextStyle(fontSize: 11.sp, color: const Color(0xFF636E72)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionList() {
    return Column(
      children: [
        if (onShare != null)
          Container(
            margin: EdgeInsets.only(bottom: 12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.w),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
              title: Text(
                '分享群聊',
                style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2D3436)),
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: 20.w,
                color: const Color(0xFFCBD2DA),
              ),
              onTap: onShare,
            ),
          ),
        Container(
          margin: EdgeInsets.only(bottom: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Text(
              '置顶聊天',
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2D3436)),
            ),
            trailing: Switch(
              value: isTop,
              onChanged: (_) => onToggleTop(),
              activeColor: const Color(0xFFFF7D45),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Text(
              '消息免打扰',
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2D3436)),
            ),
            trailing: Switch(
              value: isMuted,
              onChanged: (_) => onToggleMute(),
              activeColor: const Color(0xFFFF7D45),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Text(
              '清空聊天记录',
              style: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFFF44336), 
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: onClearHistory,
          ),
        ),
        SizedBox(height: 12.w),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Center(
              child: Text(
                isGroupOwner ? '解散群聊' : '退出群聊',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFFF44336),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onTap: onDeleteConversation,
          ),
        ),
      ],
    );
  }
}

