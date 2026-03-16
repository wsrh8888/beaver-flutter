import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/moment/moment_page/bloc/bloc.dart';
import 'package:beaver/features/moment/moment_page/bloc/event.dart';
import 'package:beaver/features/moment/moment_page/bloc/state.dart';
import 'package:beaver/features/moment/moment_page/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';

class MomentPage extends StatefulWidget {
  const MomentPage({super.key});

  @override
  State<MomentPage> createState() => _MomentPageState();
}

class _MomentPageState extends State<MomentPage> {
  late MomentBloc _momentBloc;

  @override
  void initState() {
    super.initState();
    _momentBloc = MomentBloc(MomentRepository())..add(LoadMomentsEvent());
  }

  @override
  void dispose() {
    _momentBloc.close();
    super.dispose();
  }

  void _toggleLike(String momentId, bool isLiked) {
    _momentBloc.add(ToggleLikeEvent(momentId, !isLiked));
  }

  void _previewImage(List<String> images, int currentIndex) {
    _momentBloc.add(PreviewImageEvent(images, currentIndex));
  }

  void _goToPost() {
    _momentBloc.add(GoToPostEvent());
  }

  bool _isUserLiked(List<String> likes) {
    return likes.contains('1');
  }

  String _formatTime(String time) {
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _momentBloc,
      child: BlocConsumer<MomentBloc, MomentState>(
        listener: (context, state) {
          if (state.status == MomentStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '朋友圈',
            showBack: false,
            showBackground: true,
            backgroundType: 'gradient',
            backgroundHeight: 120.w,
            isScrollable: true,
            child: Stack(
              children: [
                // 朋友圈列表
                Container(
                  padding: EdgeInsets.all(16.w),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.moments.length,
                    itemBuilder: (context, index) {
                      final moment = state.moments[index];
                      return _buildMomentItem(moment);
                    },
                  ),
                ),
                // 发布按钮
                Positioned(
                  right: 24.w,
                  bottom: 24.w,
                  child: GestureDetector(
                    onTap: _goToPost,
                    child: Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7D45),
                        borderRadius: BorderRadius.circular(28.w),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF7D45).withOpacity(0.3),
                            offset: Offset(0, 4.w),
                            blurRadius: 12.w,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.add,
                        size: 32.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMomentItem(moment) {
    final isLiked = _isUserLiked(moment.likes.map((like) => like.userId).toList());

    return Container(
      margin: EdgeInsets.only(bottom: 16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: Offset(0, 2.w),
            blurRadius: 8.w,
          ),
        ],
        border: Border.all(
          color: const Color(0xFFEBEEF5),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息
          Row(
            children: [
              BeaverAvatar(
                url: moment.fileName,
                size: 48.w,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moment.userName,
                      style: TextStyle(
                        fontSize: 16.w,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                    SizedBox(height: 4.w),
                    Text(
                      _formatTime(moment.createdAt),
                      style: TextStyle(
                        fontSize: 12.w,
                        color: const Color(0xFFB2BEC3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.w),
          // 文字内容
          if (moment.content.isNotEmpty)
            Text(
              moment.content,
              style: TextStyle(
                fontSize: 14.w,
                color: const Color(0xFF2D3436),
                height: 1.5,
              ),
            ),
          // 图片网格
          if (moment.files.isNotEmpty) ...[
            SizedBox(height: 12.w),
            _buildImageGrid(moment.files),
          ],
          SizedBox(height: 16.w),
          // 点赞按钮
          Row(
            children: [
              GestureDetector(
                onTap: () => _toggleLike(moment.id, isLiked),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                  decoration: BoxDecoration(
                    color: isLiked
                        ? const Color(0xFFFFE6D9)
                        : const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 16.w,
                        color: isLiked
                            ? const Color(0xFFFF7D45)
                            : const Color(0xFF636E72),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${moment.likes.length}',
                        style: TextStyle(
                          fontSize: 14.w,
                          color: isLiked
                              ? const Color(0xFFFF7D45)
                              : const Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // 点赞展示
          if (moment.likes.isNotEmpty) ...[
            SizedBox(height: 12.w),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    size: 14.w,
                    color: const Color(0xFFFF7D45),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Wrap(
                      spacing: 4.w,
                      children: moment.likes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final like = entry.value;
                        return Text(
                          like.userName + (index < moment.likes.length - 1 ? '、' : ''),
                          style: TextStyle(
                            fontSize: 14.w,
                            color: const Color(0xFF2D3436),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageGrid(List files) {
    final displayFiles = files.take(9).toList();
    final crossAxisCount = files.length == 1 ? 1 : files.length == 4 ? 2 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.w,
        childAspectRatio: 1,
      ),
      itemCount: displayFiles.length,
      itemBuilder: (context, index) {
        final file = displayFiles[index];
        return GestureDetector(
          onTap: () => _previewImage(
            files.map((f) => f.fileName).toList(),
            index,
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.w),
                  image: DecorationImage(
                    image: NetworkImage(file.fileName),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (files.length > 9 && index == 8)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '+${files.length - 9}',
                    style: TextStyle(
                      fontSize: 20.w,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
