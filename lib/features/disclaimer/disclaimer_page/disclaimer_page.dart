import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/disclaimer/disclaimer_page/bloc/bloc.dart';
import 'package:beaver/features/disclaimer/disclaimer_page/bloc/event.dart';
import 'package:beaver/features/disclaimer/disclaimer_page/bloc/state.dart';
import 'package:beaver/features/disclaimer/disclaimer_page/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:url_launcher/url_launcher.dart';

class DisclaimerPage extends StatefulWidget {
  const DisclaimerPage({super.key});

  @override
  State<DisclaimerPage> createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  late DisclaimerBloc _disclaimerBloc;

  @override
  void initState() {
    super.initState();
    _disclaimerBloc = DisclaimerBloc(DisclaimerRepository())..add(LoadDisclaimerEvent());
  }

  @override
  void dispose() {
    _disclaimerBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  Future<void> _openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法打开链接')),
      );
    }
  }

  void _copyQQGroup() {
    // 模拟复制QQ群号
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('QQ群号已复制')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _disclaimerBloc,
      child: BlocConsumer<DisclaimerBloc, DisclaimerState>(
        listener: (context, state) {
          if (state.status == DisclaimerStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '项目声明',
            showBack: true,
            showBackground: false,
            isScrollable: true,
            child: Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // 声明卡片
                  Container(
                    padding: EdgeInsets.all(24.w),
                    margin: EdgeInsets.only(bottom: 24.w),
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
                      children: [
                        // 图标
                        Container(
                          width: 60.w,
                          height: 60.w,
                          margin: EdgeInsets.only(bottom: 16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6D9),
                            borderRadius: BorderRadius.circular(30.w),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.info_outline,
                            size: 32.w,
                            color: const Color(0xFFFF7D45),
                          ),
                        ),
                        // 标题
                        Text(
                          '项目声明',
                          style: TextStyle(
                            fontSize: 18.w,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        SizedBox(height: 12.w),
                        // 内容
                        Text(
                          '本项目仅用于技术学习、测试和演示目的，不涉及对外营业。欢迎学习交流。',
                          style: TextStyle(
                            fontSize: 14.w,
                            color: const Color(0xFF636E72),
                            lineHeight: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // 项目链接
                  Container(
                    margin: EdgeInsets.only(bottom: 24.w),
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
                        // 标题
                        Container(
                          padding: EdgeInsets.all(20.w),
                          child: Text(
                            '项目链接',
                            style: TextStyle(
                              fontSize: 16.w,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3436),
                            ),
                          ),
                        ),
                        // 链接列表
                        ...state.projectLinks.map((link) => GestureDetector(
                              onTap: link.url.isNotEmpty
                                  ? () => _openLink(link.url)
                                  : _copyQQGroup,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 16.w,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: const Color(0xFFEBEEF5),
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // 图标
                                    Container(
                                      width: 48.w,
                                      height: 48.w,
                                      margin: EdgeInsets.only(right: 16.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE6D9),
                                        borderRadius: BorderRadius.circular(12.w),
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        _getIconForLink(link.icon),
                                        size: 24.w,
                                        color: const Color(0xFFFF7D45),
                                      ),
                                    ),
                                    // 信息
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            link.name,
                                            style: TextStyle(
                                              fontSize: 14.w,
                                              color: const Color(0xFF2D3436),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 4.w),
                                          Text(
                                            link.description,
                                            style: TextStyle(
                                              fontSize: 12.w,
                                              color: const Color(0xFFB2BEC3),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // 箭头
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16.w,
                                      color: const Color(0xFFB2BEC3),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  // 作者信息
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
                      children: [
                        // 作者信息
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // 头像
                                Container(
                                  width: 56.w,
                                  height: 56.w,
                                  margin: EdgeInsets.only(right: 16.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF7D45),
                                    borderRadius: BorderRadius.circular(28.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    state.authorInfo?.name[0] ?? 'W',
                                    style: TextStyle(
                                      fontSize: 24.w,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                // 信息
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.authorInfo?.name ?? 'wsrh8888',
                                      style: TextStyle(
                                        fontSize: 16.w,
                                        color: const Color(0xFF2D3436),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4.w),
                                    Text(
                                      state.authorInfo?.description ?? '全栈开发者',
                                      style: TextStyle(
                                        fontSize: 14.w,
                                        color: const Color(0xFF636E72),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // GitHub链接
                            GestureDetector(
                              onTap: state.authorInfo != null
                                  ? () => _openLink(state.authorInfo!.githubUrl)
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.w,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F2F5),
                                  borderRadius: BorderRadius.circular(16.w),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.code,
                                      size: 16.w,
                                      color: const Color(0xFF636E72),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'GitHub主页',
                                      style: TextStyle(
                                        fontSize: 12.w,
                                        color: const Color(0xFF636E72),
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
          );
        },
      ),
    );
  }

  IconData _getIconForLink(String icon) {
    switch (icon) {
      case 'mobile':
        return Icons.smartphone;
      case 'server':
        return Icons.cloud;
      case 'desktop':
        return Icons.desktop_windows;
      case 'doc':
        return Icons.description;
      case 'video':
        return Icons.video_library;
      case 'github':
        return Icons.code;
      default:
        return Icons.link;
    }
  }
}
