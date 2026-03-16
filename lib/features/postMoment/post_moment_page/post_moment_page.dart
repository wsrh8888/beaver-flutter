import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/postMoment/post_moment_page/bloc/bloc.dart';
import 'package:beaver/features/postMoment/post_moment_page/bloc/event.dart';
import 'package:beaver/features/postMoment/post_moment_page/bloc/state.dart';
import 'package:beaver/features/postMoment/post_moment_page/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class PostMomentPage extends StatefulWidget {
  const PostMomentPage({super.key});

  @override
  State<PostMomentPage> createState() => _PostMomentPageState();
}

class _PostMomentPageState extends State<PostMomentPage> {
  late PostMomentBloc _postMomentBloc;
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _postMomentBloc = PostMomentBloc(PostMomentRepository());
  }

  @override
  void dispose() {
    _postMomentBloc.close();
    _contentController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _handlePost() {
    _postMomentBloc.add(PostMomentSubmitEvent());
  }

  void _chooseImage() {
    // 模拟选择图片
    _postMomentBloc.add(AddImageEvent('https://neeko-copilot.bytedance.net/api/text2image?prompt=new%20image&size=512x512'));
  }

  void _removeImage(int index) {
    _postMomentBloc.add(RemoveImageEvent(index));
  }

  void _previewImage(int index) {
    _postMomentBloc.add(PreviewImageEvent(index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _postMomentBloc,
      child: BlocConsumer<PostMomentBloc, PostMomentState>(
        listener: (context, state) {
          if (state.status == PostMomentStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          } else if (state.status == PostMomentStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发布成功')),
            );
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pop();
            });
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '发布朋友圈',
            showBack: true,
            showBackground: true,
            backgroundType: 'gradient',
            backgroundHeight: 120.w,
            isScrollable: true,
            rightAction: GestureDetector(
              onTap: state.canPost ? _handlePost : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                decoration: BoxDecoration(
                  color: state.canPost
                      ? const Color(0xFFFF7D45)
                      : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(16.w),
                ),
                child: Text(
                  '发布',
                  style: TextStyle(
                    fontSize: 14.w,
                    color: state.canPost ? Colors.white : const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 文本输入区域
                  Container(
                    margin: EdgeInsets.only(bottom: 24.w),
                    child: TextField(
                      controller: _contentController,
                      onChanged: (value) {
                        _postMomentBloc.add(UpdateContentEvent(value));
                      },
                      maxLines: 10,
                      minLines: 5,
                      maxLength: 1000,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '分享此刻的想法...',
                        hintStyle: TextStyle(
                          fontSize: 16.w,
                          color: const Color(0xFFB2BEC3),
                        ),
                        counterText: '',
                      ),
                      style: TextStyle(
                        fontSize: 16.w,
                        color: const Color(0xFF2D3436),
                        height: 1.5,
                      ),
                    ),
                  ),
                  // 字数计数器
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(bottom: 24.w),
                    child: Text(
                      '${state.content.length}/1000',
                      style: TextStyle(
                        fontSize: 12.w,
                        color: const Color(0xFFB2BEC3),
                      ),
                    ),
                  ),
                  // 图片上传区域
                  Container(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.w,
                        childAspectRatio: 1,
                      ),
                      itemCount: state.mediaList.length + (state.mediaList.length < 9 ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < state.mediaList.length) {
                          return _buildMediaItem(state.mediaList[index], index);
                        } else {
                          return _buildAddMediaItem();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaItem(String imageUrl, int index) {
    return GestureDetector(
      onTap: () => _previewImage(index),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.w),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 4.w,
            right: 4.w,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                alignment: Alignment.center,
                child: Text(
                  '×',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMediaItem() {
    return GestureDetector(
      onTap: _chooseImage,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1.w,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.add,
          size: 40.w,
          color: const Color(0xFFB2BEC3),
        ),
      ),
    );
  }
}
