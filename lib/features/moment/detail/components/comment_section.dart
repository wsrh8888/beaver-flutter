import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/api/moment.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/store/contact/contact.dart';

class MomentCommentSection extends StatelessWidget {
  final List<IMomentCommentModel> comments;
  final void Function(IMomentCommentModel comment) onReply;
  final void Function(IMomentCommentModel rootComment) onLoadMoreChildren;

  const MomentCommentSection({
    super.key,
    required this.comments,
    required this.onReply,
    required this.onLoadMoreChildren,
  });

  String _formatTime(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return '刚刚';
      if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
      if (diff.inHours < 24) return '${diff.inHours}小时前';
      if (diff.inDays < 30) return '${diff.inDays}天前';
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  String _getName(ContactStore contactStore, IMomentCommentModel comment) {
    final info = contactStore.getContact(comment.userId);
    return info?.nickname.isNotEmpty == true
        ? info!.nickname
        : (comment.userName.isNotEmpty ? comment.userName : (comment.nickName ?? ''));
  }

  String? _getAvatar(ContactStore contactStore, IMomentCommentModel comment) {
    final info = contactStore.getContact(comment.userId);
    return info?.avatar ?? comment.avatar;
  }

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.w),
        child: Center(
          child: Text(
            '暂无评论',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 16.w),
      itemCount: comments.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.w),
      itemBuilder: (context, index) {
        final root = comments[index];
        final replies = root.children ?? [];
        final loadedCount = replies.length;
        final totalCount = root.childCount ?? loadedCount;
        final contactStore = context.read<ContactStore>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCommentItem(
              context,
              contactStore,
              root,
              showReplyTarget: false,
            ),
            if (replies.isNotEmpty)
              Container(
                margin: EdgeInsets.only(left: 44.w, top: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: Column(
                  children: [
                    for (final reply in replies)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.w),
                        child: _buildCommentItem(
                          context,
                          contactStore,
                          reply,
                          showReplyTarget: true,
                          replyTargetName: reply.replyToUserName ??
                              _getName(contactStore, root),
                        ),
                      ),
                  ],
                ),
              ),
            if (totalCount > loadedCount)
              GestureDetector(
                onTap: () => onLoadMoreChildren(root),
                child: Padding(
                  padding: EdgeInsets.only(left: 44.w, top: 6.w, bottom: 4.w),
                  child: Text(
                    '共 $totalCount 条回复',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF4678BE),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCommentItem(
    BuildContext context,
    ContactStore contactStore,
    IMomentCommentModel comment, {
    required bool showReplyTarget,
    String? replyTargetName,
  }) {
    final name = _getName(contactStore, comment);
    final avatar = _getAvatar(contactStore, comment);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(showReplyTarget ? 12.w : 18.w),
          child: SizedBox(
            width: showReplyTarget ? 24.w : 36.w,
            height: showReplyTarget ? 24.w : 36.w,
            child: BeaverCachedImage(
              fileUrl: avatar,
              type: CacheType.avatar,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showReplyTarget && replyTargetName != null)
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF576B95),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        '回复',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF999999),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        replyTargetName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF576B95),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF576B95),
                  ),
                ),
              SizedBox(height: 4.w),
              Text(
                comment.content,
                style: TextStyle(
                  fontSize: showReplyTarget ? 15.sp : 14.sp,
                  height: 1.5,
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4.w),
              Row(
                children: [
                  Text(
                    _formatTime(comment.createdAt),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Text(
                      '|',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFFCCCCCC),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onReply(comment),
                    child: Text(
                      '回复',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
