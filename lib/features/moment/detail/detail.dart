import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/moment/detail/bloc/bloc.dart';
import 'package:beaver/features/moment/detail/bloc/event.dart';
import 'package:beaver/features/moment/detail/bloc/state.dart';
import 'package:beaver/features/moment/detail/components/bottom_input.dart';
import 'package:beaver/features/moment/detail/components/comment_section.dart';
import 'package:beaver/features/moment/detail/components/like_section.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/store/contact/contact.dart';
import 'package:beaver/store/user/user.dart';
import 'package:beaver/types/api/moment.dart';
import 'package:beaver/types/cache.dart';

class MomentDetailPage extends StatelessWidget {
  final String momentId;
  final String? replyCommentId;

  const MomentDetailPage({
    super.key,
    required this.momentId,
    this.replyCommentId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MomentDetailBloc(replyCommentId: replyCommentId)
        ..add(LoadMomentDetailEvent(momentId)),
      child: MomentDetailView(momentId: momentId),
    );
  }
}

class MomentDetailView extends StatefulWidget {
  final String momentId;

  const MomentDetailView({super.key, required this.momentId});

  @override
  State<MomentDetailView> createState() => _MomentDetailViewState();
}

class _MomentDetailViewState extends State<MomentDetailView> {
  final ScrollController _scrollController = ScrollController();
  int _openInputKey = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 120) {
      context.read<MomentDetailBloc>().add(const LoadMoreCommentsEvent());
    }
  }

  String _formatTime(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes == 0 ? 1 : diff.inMinutes}分钟前';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}小时前';
      } else if (diff.inDays < 30) {
        return '${diff.inDays}天前';
      }
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  String _replyPlaceholder(MomentDetailState state) {
    final target = state.replyTarget;
    if (target == null) return '说点什么...';
    final contactStore = context.read<ContactStore>();
    final info = contactStore.getContact(target.userId);
    final name = info?.nickname.isNotEmpty == true
        ? info!.nickname
        : target.userName;
    return '回复 $name';
  }

  void _openReplyInput(IMomentCommentModel comment) {
    context.read<MomentDetailBloc>().add(SetReplyTargetEvent(comment));
    setState(() => _openInputKey++);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MomentDetailBloc, MomentDetailState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != prev.errorMessage ||
          (prev.replyTarget == null && curr.replyTarget != null),
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          BeaverToast.show(context, state.errorMessage!);
        }
        if (state.replyTarget != null) {
          setState(() => _openInputKey++);
        }
      },
      builder: (context, state) {
        final moment = state.moment;
        final userState = context.watch<UserStore>().state;
        final contactStore = context.watch<ContactStore>();
        final userInfo = contactStore.getContact(moment?.userId ?? '');

        return BeaverLayout(
          title: '动态详情',
          showBack: true,
          isScrollable: false,
          child: state.status == MomentDetailStatus.loading && moment == null
              ? const Center(child: CircularProgressIndicator())
              : state.status == MomentDetailStatus.error && moment == null
                  ? Center(
                      child: Text(
                        state.errorMessage ?? '加载失败',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF636E72),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            color: const Color(0xFFFF7D45),
                            onRefresh: () async {
                              context
                                  .read<MomentDetailBloc>()
                                  .add(const RefreshMomentDetailEvent());
                            },
                            child: ListView(
                              controller: _scrollController,
                              padding: EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 12.w),
                              children: [
                                if (moment != null) ...[
                                  _buildMomentContent(
                                    moment,
                                    userInfo?.nickname ?? moment.userName,
                                    userInfo?.avatar ?? moment.avatar,
                                  ),
                                  _buildTabBar(state),
                                  if (state.activeTab == MomentDetailTab.comments)
                                    MomentCommentSection(
                                      comments: moment.comments,
                                      onReply: _openReplyInput,
                                      onLoadMoreChildren: (root) {
                                        context.read<MomentDetailBloc>().add(
                                              LoadChildCommentsEvent(root),
                                            );
                                      },
                                    )
                                  else
                                    MomentLikeSection(likes: moment.likes),
                                  if (state.isLoadingComments)
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 16.w),
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        if (moment != null && state.replyTarget != null)
                          _buildReplyBanner(state),
                        if (moment != null)
                          MomentBottomInput(
                            isLiked: moment.isLiked,
                            replyPlaceholder: _replyPlaceholder(state),
                            openInputKey: _openInputKey,
                            onQuickLike: () {
                              final me = contactStore.getContact(
                                userState.currentUserId,
                              );
                              context.read<MomentDetailBloc>().add(
                                    ToggleLikeEvent(
                                      currentUserId: userState.currentUserId,
                                      currentUserName:
                                          me?.nickname ?? '我',
                                      currentUserAvatar: me?.avatar ?? '',
                                    ),
                                  );
                            },
                            onSendComment: (text) {
                              context.read<MomentDetailBloc>().add(
                                    AddCommentEvent(
                                      text,
                                      targetComment: state.replyTarget,
                                    ),
                                  );
                            },
                            onCloseReply: () {
                              context.read<MomentDetailBloc>().add(
                                    const SetReplyTargetEvent(null),
                                  );
                            },
                          ),
                      ],
                    ),
        );
      },
    );
  }

  Widget _buildReplyBanner(MomentDetailState state) {
    final target = state.replyTarget!;
    final contactStore = context.read<ContactStore>();
    final info = contactStore.getContact(target.userId);
    final name = info?.nickname.isNotEmpty == true
        ? info!.nickname
        : target.userName;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      color: const Color(0xFFFFF4EC),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '正在回复 $name',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFFE86835)),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<MomentDetailBloc>().add(const SetReplyTargetEvent(null));
            },
            child: Text(
              '取消',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF999999)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(MomentDetailState state) {
    final moment = state.moment!;
    return Container(
      margin: EdgeInsets.only(top: 12.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E5E5), width: 0.5.w),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem(
            label: '评论 ${moment.commentCount}',
            active: state.activeTab == MomentDetailTab.comments,
            onTap: () => context.read<MomentDetailBloc>().add(
                  const SwitchTabEvent(MomentDetailTab.comments),
                ),
          ),
          _buildTabItem(
            label: '点赞 ${moment.likeCount}',
            active: state.activeTab == MomentDetailTab.likes,
            onTap: () => context.read<MomentDetailBloc>().add(
                  const SwitchTabEvent(MomentDetailTab.likes),
                ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => context.read<MomentDetailBloc>().add(
                  const RefreshMomentDetailEvent(),
                ),
            icon: Icon(Icons.refresh, size: 18.w, color: const Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? const Color(0xFFFF7D45) : Colors.transparent,
              width: 2.w,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: active ? const Color(0xFFFF7D45) : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildMomentContent(
    IMomentListItem moment,
    String userName,
    String? avatar,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: const Color(0xFFEBEEF5), width: 0.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.w),
                child: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: BeaverCachedImage(
                    fileUrl: avatar,
                    type: CacheType.avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    Text(
                      _formatTime(moment.createdAt),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (moment.content.isNotEmpty) ...[
            SizedBox(height: 12.w),
            Text(
              moment.content,
              style: TextStyle(
                fontSize: 15.sp,
                height: 1.6,
                color: const Color(0xFF333333),
              ),
            ),
          ],
          if (moment.files.isNotEmpty) ...[
            SizedBox(height: 12.w),
            _buildImagesGrid(moment.files),
          ],
        ],
      ),
    );
  }

  Widget _buildImagesGrid(List<IMomentFileModel> files) {
    final displayFiles = files.length > 9 ? files.sublist(0, 9) : files;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = files.length == 1
            ? 1
            : (files.length == 2 || files.length == 4 ? 2 : 3);
        final spacing = 2.w;
        final itemWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: displayFiles.asMap().entries.map((entry) {
            final idx = entry.key;
            final file = entry.value;
            final isLast = idx == 8 && files.length > 9;

            return ClipRRect(
              borderRadius: BorderRadius.circular(4.w),
              child: Container(
                width: files.length == 1 ? constraints.maxWidth * 0.7 : itemWidth,
                height: files.length == 1 ? constraints.maxWidth * 0.7 : itemWidth,
                color: const Color(0xFFF8F9FA),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (file.type == 2)
                      BeaverCachedImage(
                        fileUrl: file.fileKey,
                        type: CacheType.image,
                        fit: BoxFit.cover,
                      )
                    else
                      Icon(
                        Icons.insert_drive_file_outlined,
                        color: const Color(0xFFB2BEC3),
                        size: 24.w,
                      ),
                    if (isLast)
                      Container(
                        color: Colors.black.withValues(alpha: 0.6),
                        alignment: Alignment.center,
                        child: Text(
                          '+${files.length - 9}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
