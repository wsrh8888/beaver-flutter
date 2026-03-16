import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/setting/about/bloc/bloc.dart';
import 'package:beaver/features/setting/about/bloc/event.dart';
import 'package:beaver/features/setting/about/bloc/state.dart';
import 'package:beaver/features/setting/about/data/repositories/repository.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late AboutBloc _aboutBloc;

  @override
  void initState() {
    super.initState();
    _aboutBloc = AboutBloc(AboutRepository())..add(LoadAppInfoEvent());
  }

  @override
  void dispose() {
    _aboutBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider.value(
        value: _aboutBloc,
        child: BlocConsumer<AboutBloc, AboutState>(
          listener: (context, state) {
            if (state.status == AboutState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? '发生错误')),
              );
            }
          },
          builder: (context, state) {
            final appInfo = state.appInfo ?? const AppInfo(
              name: 'Beaver',
              version: '1.0.0',
              developer: 'Beaver Team',
              description: 'Beaver是一款致力于帮助用户拓展社交圈，发现志同道合朋友的即时通讯应用。我们相信真实的人际连接比以往任何时候都更加珍贵�?,
            );

            return Stack(
              children: [
                // 背景元素
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      // 圆形背景
                      Positioned(
                        top: -320.w,
                        right: -200.w,
                        child: Container(
                          width: 600.w,
                          height: 600.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(300.w),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFF7D45),
                                Color(0xFFE86835),
                              ],
                            ),
                          ),
                          opacity: 0.1,
                        ),
                      ),
                      Positioned(
                        bottom: -200.w,
                        left: -200.w,
                        child: Container(
                          width: 400.w,
                          height: 400.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200.w),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFF7D45),
                                Color(0xFFE86835),
                              ],
                            ),
                          ),
                          opacity: 0.1,
                        ),
                      ),
                      // 装饰�?
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.2,
                        left: MediaQuery.of(context).size.width * 0.1,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            color: const Color(0xFFFFE6D9),
                          ),
                          opacity: 0.8,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.3,
                        right: MediaQuery.of(context).size.width * 0.15,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            color: const Color(0xFFFFE6D9),
                          ),
                          opacity: 0.5,
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.25,
                        left: MediaQuery.of(context).size.width * 0.2,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            color: const Color(0xFFFFE6D9),
                          ),
                          opacity: 0.7,
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.15,
                        right: MediaQuery.of(context).size.width * 0.1,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            color: const Color(0xFFFFE6D9),
                          ),
                          opacity: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
                // 导航�?
                Container(
                  height: 112.w,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 32.w,
                    right: 32.w,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: GestureDetector(
                          onTap: _goBack,
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.w),
                              color: Colors.white.withOpacity(0.9),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  offset: Offset(0, 8.w),
                                  blurRadius: 24.w,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_back,
                              size: 40.w,
                              color: const Color(0xFF2D3436),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '关于我们',
                        style: TextStyle(
                          fontSize: 36.w,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3436),
                        ),
                      ),
                    ],
                  ),
                ),
                // 主要内容
                Container(
                  margin: EdgeInsets.only(top: 112.w + MediaQuery.of(context).padding.top),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          width: 200.w,
                          height: 200.w,
                          margin: EdgeInsets.only(bottom: 64.w, top: 20.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(76.w),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFF7D45),
                                Color(0xFFE86835),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF7D45).withOpacity(0.3),
                                offset: Offset(0, 24.w),
                                blurRadius: 48.w,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'B',
                            style: TextStyle(
                              fontSize: 80.w,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // 应用名称
                        Container(
                          margin: EdgeInsets.only(bottom: 24.w),
                          child: Stack(
                            children: [
                              Text(
                                appInfo.name,
                                style: TextStyle(
                                  fontSize: 64.w,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF2D3436),
                                ),
                              ),
                              Positioned(
                                bottom: 4.w,
                                left: -12.w,
                                right: -12.w,
                                height: 20.w,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE6D9),
                                    borderRadius: BorderRadius.circular(12.w),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 版本�?
                        Container(
                          margin: EdgeInsets.only(bottom: 48.w),
                          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6D9),
                            borderRadius: BorderRadius.circular(40.w),
                          ),
                          child: Text(
                            appInfo.version,
                            style: TextStyle(
                              fontSize: 32.w,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF7D45),
                            ),
                          ),
                        ),
                        // 描述
                        Container(
                          margin: EdgeInsets.only(bottom: 80.w, left: 48.w, right: 48.w),
                          child: Text(
                            appInfo.description,
                            style: TextStyle(
                              fontSize: 34.w,
                              lineHeight: 1.8,
                              color: const Color(0xFF636E72),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // 团队信息
                        Column(
                          children: [
                            Text(
                              '�?,
                              style: TextStyle(
                                fontSize: 28.w,
                                color: const Color(0xFFB2BEC3),
                              ),
                            ),
                            SizedBox(height: 16.w),
                            Text(
                              appInfo.developer,
                              style: TextStyle(
                                fontSize: 36.w,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3436),
                              ),
                            ),
                            SizedBox(height: 48.w),
                            Text(
                              '© 2025 版权所�?,
                              style: TextStyle(
                                fontSize: 24.w,
                                color: const Color(0xFFB2BEC3),
                              ),
                            ),
                            SizedBox(height: 40.w),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

