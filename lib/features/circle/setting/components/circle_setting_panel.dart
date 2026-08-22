import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/types/api/circle.dart';
import 'package:beaver/types/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 圈子设置面板（对齐群聊设置 / PC 圈子详情）
class CircleSettingPanel extends StatelessWidget {
  final String circleId;
  final String name;
  final String avatar;
  final String description;
  final List<ICircleMemberItem> members;
  final bool isOwner;
  final bool canManage;
  final bool isTop;
  final bool isMuted;
  final ContactStore contactStore;
  final VoidCallback onAddMember;
  final VoidCallback onShare;
  final VoidCallback onToggleTop;
  final VoidCallback onToggleMute;
  final VoidCallback onQuitOrDelete;
  final ValueChanged<String> onRemoveMember;

  const CircleSettingPanel({
    super.key,
    required this.circleId,
    required this.name,
    required this.avatar,
    required this.description,
    required this.members,
    required this.isOwner,
    required this.canManage,
    required this.isTop,
    required this.isMuted,
    required this.contactStore,
    required this.onAddMember,
    required this.onShare,
    required this.onToggleTop,
    required this.onToggleMute,
    required this.onQuitOrDelete,
    required this.onRemoveMember,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildMembersSection(context),
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
                  name.isNotEmpty ? name : '圈子',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                SizedBox(height: 4.w),
                Text(
                  '圈ID: $circleId  ·  ${members.length}人',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF636E72),
                  ),
                ),
                if (description.isNotEmpty) ...[
                  SizedBox(height: 4.w),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF99A3AD),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSection(BuildContext context) {
    final displayMembers = members.take(canManage ? 19 : 20).toList();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '圈成员',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
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
            itemCount: displayMembers.length + (canManage ? 1 : 0),
            itemBuilder: (context, index) {
              if (canManage && index == displayMembers.length) {
                return _buildAddButton();
              }
              return _buildMemberItem(context, displayMembers[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMemberItem(BuildContext context, ICircleMemberItem member) {
    final contact = contactStore.getContact(member.userId);
    final displayAvatar =
        (contact?.avatar?.isNotEmpty == true) ? contact!.avatar! : member.avatar;
    final displayName = (contact?.nickname.isNotEmpty == true)
        ? contact!.nickname
        : (member.userName.isNotEmpty
            ? member.userName
            : member.userId);

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
            if (canManage && member.role != 1)
              Positioned(
                top: -4.w,
                right: -4.w,
                child: GestureDetector(
                  onTap: () => _confirmRemove(context, member),
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
          displayName,
          style: TextStyle(fontSize: 11.sp, color: const Color(0xFF636E72)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _confirmRemove(BuildContext context, ICircleMemberItem member) {
    final name = member.userName.isNotEmpty ? member.userName : member.userId;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('移除成员'),
        content: Text('确定要将 $name 移出圈子吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onRemoveMember(member.userId);
            },
            child: const Text(
              '移除',
              style: TextStyle(color: Color(0xFFFF5252)),
            ),
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
        _tileCard(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Text(
              '分享圈子',
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
        _tileCard(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Text(
              '置顶聊天',
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2D3436)),
            ),
            trailing: Switch(
              value: isTop,
              onChanged: (_) => onToggleTop(),
              activeThumbColor: const Color(0xFFFF7D45),
            ),
          ),
        ),
        _tileCard(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Text(
              '消息免打扰',
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2D3436)),
            ),
            trailing: Switch(
              value: isMuted,
              onChanged: (_) => onToggleMute(),
              activeThumbColor: const Color(0xFFFF7D45),
            ),
          ),
        ),
        SizedBox(height: 12.w),
        _tileCard(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
            title: Center(
              child: Text(
                isOwner ? '解散圈子' : '退出圈子',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFFF44336),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onTap: onQuitOrDelete,
          ),
        ),
      ],
    );
  }

  Widget _tileCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: child,
    );
  }
}
