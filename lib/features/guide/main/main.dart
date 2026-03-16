import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/guide/guide_page/bloc/bloc.dart';
import 'package:beaver/features/guide/guide_page/bloc/event.dart';
import 'package:beaver/features/guide/guide_page/bloc/state.dart';
import 'package:beaver/features/guide/guide_page/data/repositories/repository.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  late GuideBloc _guideBloc;

  @override
  void initState() {
    super.initState();
    _guideBloc = GuideBloc(GuideRepository())..add(LoadGuideConfigEvent());
  }

  @override
  void dispose() {
    _guideBloc.close();
    super.dispose();
  }

  void _goToRegister() {
    _guideBloc.add(NavigateToRegisterEvent());
  }

  void _goToLogin() {
    _guideBloc.add(NavigateToLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _guideBloc,
      child: BlocConsumer<GuideBloc, GuideState>(
        listener: (context, state) {
          if (state.status == GuideStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  // 背景图片
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          state.guideConfig?.logo ?? 'https://neeko-copilot.bytedance.net/api/text2image?prompt=messaging%20app%20logo%20on%20gradient%20background&size=1024x1024',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // 按钮区域
                  Positioned(
                    bottom: 265.w,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 注册按钮
                        GestureDetector(
                          onTap: _goToRegister,
                          child: Container(
                            width: 322.w,
                            height: 86.w,
                            margin: EdgeInsets.only(right: 20.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F7),
                              borderRadius: BorderRadius.circular(40.w),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '注册',
                              style: TextStyle(
                                fontSize: 32.w,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ),
                        ),
                        // 登录按钮
                        GestureDetector(
                          onTap: _goToLogin,
                          child: Container(
                            width: 322.w,
                            height: 86.w,
                            margin: EdgeInsets.only(left: 20.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5F87F6),
                              borderRadius: BorderRadius.circular(40.w),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '登录',
                              style: TextStyle(
                                fontSize: 32.w,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ],
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
