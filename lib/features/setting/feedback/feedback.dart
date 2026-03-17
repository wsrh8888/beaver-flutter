import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/setting/feedback/bloc/bloc.dart';
import 'package:beaver/features/setting/feedback/bloc/event.dart';
import 'package:beaver/features/setting/feedback/bloc/state.dart';
import 'package:beaver/features/setting/feedback/data/repositories/repository.dart';
import 'package:beaver/features/setting/feedback/data/models/feedback.dart';
import 'package:beaver/shared/ui/button/button.dart';
import 'package:beaver/shared/ui/header/header.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  late FeedbackBloc _feedbackBloc;
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _feedbackBloc = FeedbackBloc(FeedbackRepository())..add(LoadFeedbackTypesEvent());
    _contentController.addListener(() {
      _feedbackBloc.add(UpdateContentEvent(_contentController.text));
    });
  }

  @override
  void dispose() {
    _feedbackBloc.close();
    _contentController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _selectFeedbackType(int type) {
    _feedbackBloc.add(SelectFeedbackTypeEvent(type));
  }

  void _chooseImage() {
    // 模拟选择图片
    final image = UploadedImage(
      fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=screenshot&size=512x512',
      name: 'screenshot.jpg',
    );
    _feedbackBloc.add(AddImageEvent(image));
  }

  void _removeImage(int index) {
    _feedbackBloc.add(RemoveImageEvent(index));
  }

  void _submitFeedback() {
    _feedbackBloc.add(SubmitFeedbackEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _feedbackBloc,
      child: BlocConsumer<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state.status == FeedbackStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          } else if (state.status == FeedbackStatus.success && state.selectedType != null) {
            BeaverToast.show(context, '提交成功');
            Future.delayed(const Duration(seconds: 1), () {
              _goBack();
            });
          }
        },
        builder: (context, state) {
          final canSubmit = state.selectedType != null && state.content.trim().isNotEmpty;

          return BeaverLayout(
            title: '意见反馈',
            showBack: true,
            onBack: _goBack,
            showBackground: false,
            isScrollable: true,
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // 主卡
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          offset: Offset(0, 4.w),
                          blurRadius: 12.w,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 反馈类型选择
                        Container(
                          margin: EdgeInsets.only(bottom: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '反馈类型',
                                style: TextStyle(
                                  fontSize: 16.w,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3436),
                                ),
                              ),
                              SizedBox(height: 12.w),
                              Wrap(
                                spacing: 12.w,
                                runSpacing: 12.w,
                                children: state.feedbackTypes.map((type) => GestureDetector(
                                      onTap: () => _selectFeedbackType(type.value),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 8.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: state.selectedType == type.value
                                              ? const Color(0xFFFFE6D9)
                                              : const Color(0xFFF0F2F5),
                                          borderRadius: BorderRadius.circular(16.w),
                                          border: Border.all(
                                            color: state.selectedType == type.value
                                                ? const Color(0xFFFF7D45)
                                                : const Color(0xFFEBEEF5),
                                            width: 2.w,
                                          ),
                                        ),
                                        child: Text(
                                          type.label,
                                          style: TextStyle(
                                            fontSize: 14.w,
                                            color: state.selectedType == type.value
                                                ? const Color(0xFFFF7D45)
                                                : const Color(0xFF636E72),
                                          ),
                                        ),
                                      ),
                                    )).toList(),
                              ),
                            ],
                          ),
                        ),
                        // 反馈内容
                        Container(
                          margin: EdgeInsets.only(bottom: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '问题描述',
                                style: TextStyle(
                                  fontSize: 16.w,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3436),
                                ),
                              ),
                              SizedBox(height: 12.w),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12.w),
                                  border: Border.all(
                                    color: const Color(0xFFEBEEF5),
                                    width: 2.w,
                                  ),
                                ),
                                child: TextField(
                                  controller: _contentController,
                                  maxLength: 500,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '请详细描述您遇到的问题或建议...',
                                    hintStyle: TextStyle(
                                      fontSize: 14.w,
                                      color: const Color(0xFFB2BEC3),
                                    ),
                                    contentPadding: EdgeInsets.all(16.w),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.w),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${state.charCount}/500',
                                  style: TextStyle(
                                    fontSize: 12.w,
                                    color: const Color(0xFFB2BEC3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 图片上传
                        Container(
                          margin: EdgeInsets.only(bottom: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '添加截图',
                                    style: TextStyle(
                                      fontSize: 16.w,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2D3436),
                                    ),
                                  ),
                                  Text(
                                    '选填，最多3张',
                                    style: TextStyle(
                                      fontSize: 12.w,
                                      color: const Color(0xFFB2BEC3),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.w),
                              Row(
                                children: [
                                  // 已上传图片
                                  ...state.uploadedImages.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final image = entry.value;
                                    return Container(
                                      margin: EdgeInsets.only(right: 12.w),
                                      width: 80.w,
                                      height: 80.w,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 80.w,
                                            height: 80.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.w),
                                              image: DecorationImage(
                                                image: NetworkImage(image.fileName),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -8.w,
                                            right: -8.w,
                                            child: GestureDetector(
                                              onTap: () => _removeImage(index),
                                              child: Container(
                                                width: 24.w,
                                                height: 24.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
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
                                  }),
                                  // 上传按钮
                                  if (state.uploadedImages.length < 3)
                                    GestureDetector(
                                      onTap: _chooseImage,
                                      child: Container(
                                        width: 80.w,
                                        height: 80.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9FAFB),
                                          borderRadius: BorderRadius.circular(8.w),
                                          border: Border.all(
                                            color: const Color(0xFFEBEEF5),
                                            width: 2.w,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.upload,
                                              size: 24.w,
                                              color: const Color(0xFFB2BEC3),
                                            ),
                                            SizedBox(height: 4.w),
                                            Text(
                                              '上传图片',
                                              style: TextStyle(
                                                fontSize: 12.w,
                                                color: const Color(0xFFB2BEC3),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 提交按钮
                  Container(
                    padding: EdgeInsets.all(16.w),
                    child: GestureDetector(
                      onTap: canSubmit ? _submitFeedback : null,
                      child: Container(
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: canSubmit ? const Color(0xFFFF7D45) : const Color(0xFFB2BEC3),
                          borderRadius: BorderRadius.circular(24.w),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '提交反馈',
                          style: TextStyle(
                            fontSize: 16.w,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
}

