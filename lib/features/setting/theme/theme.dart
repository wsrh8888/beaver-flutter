import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/setting/theme/bloc/bloc.dart';
import 'package:beaver/features/setting/theme/bloc/event.dart';
import 'package:beaver/features/setting/theme/bloc/state.dart';
import 'package:beaver/features/setting/theme/data/repositories/repository.dart';
import 'package:beaver/shared/ui/header/header.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  late ThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();
    _themeBloc = ThemeBloc(ThemeRepository())..add(LoadThemesEvent());
  }

  @override
  void dispose() {
    _themeBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _selectTheme(String themeName) {
    _themeBloc.add(SelectThemeEvent(themeName));
    BeaverToast.show(context, '主题切换成功');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _themeBloc,
      child: BlocConsumer<ThemeBloc, ThemeState>(
        listener: (context, state) {
          if (state.status == ThemeStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '主题设置',
            showBack: true,
            onBack: _goBack,
            showBackground: true,
            isScrollable: true,
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // 主题选择卡片
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
                        // 主题标题
                        Container(
                          margin: EdgeInsets.only(bottom: 24.w),
                          child: Column(
                            children: [
                              Text(
                                '选择主题',
                                style: TextStyle(
                                  fontSize: 18.w,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3436),
                                ),
                              ),
                              SizedBox(height: 8.w),
                              Text(
                                '选择你喜欢的主题风格',
                                style: TextStyle(
                                  fontSize: 14.w,
                                  color: const Color(0xFFB2BEC3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 主题网格
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 16.w,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: state.availableThemes.length,
                          itemBuilder: (context, index) {
                            final theme = state.availableThemes[index];
                            final isActive = state.currentTheme == theme.name;
                            return GestureDetector(
                              onTap: () => _selectTheme(theme.name),
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: isActive ? const Color(0xFFFFE6D9) : const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12.w),
                                  border: Border.all(
                                    color: isActive ? const Color(0xFFFF7D45) : Colors.transparent,
                                    width: 2.w,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // 主题预览
                                    Container(
                                      width: double.infinity,
                                      height: 60.w,
                                      margin: EdgeInsets.only(bottom: 8.w),
                                      decoration: BoxDecoration(
                                        color: theme.colors.background,
                                        borderRadius: BorderRadius.circular(8.w),
                                        border: Border.all(
                                          color: theme.colors.divider,
                                          width: 1.w,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          // 预览头部
                                          Container(
                                            height: 16.w,
                                            decoration: BoxDecoration(
                                              color: theme.colors.primary,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.w),
                                                topRight: Radius.circular(8.w),
                                              ),
                                            ),
                                          ),
                                          // 预览内容
                                          Padding(
                                            padding: EdgeInsets.all(6.w),
                                            child: Column(
                                              children: [
                                                // 预览文本
                                                Container(
                                                  height: 8.w,
                                                  width: double.infinity,
                                                  color: theme.colors.textBody.withOpacity(0.3),
                                                ),
                                                SizedBox(height: 3.w),
                                                // 预览按钮
                                                Container(
                                                  height: 12.w,
                                                  width: 60.w,
                                                  decoration: BoxDecoration(
                                                    color: theme.colors.primary,
                                                    borderRadius: BorderRadius.circular(6.w),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // 主题标签
                                    Text(
                                      theme.label,
                                      style: TextStyle(
                                        fontSize: 14.w,
                                        color: const Color(0xFF636E72),
                                      ),
                                    ),
                                    // 选中标记
                                    if (isActive)
                                      Container(
                                        margin: EdgeInsets.only(top: 4.w),
                                        width: 20.w,
                                        height: 20.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF7D45),
                                          borderRadius: BorderRadius.circular(10.w),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '√',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.w,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.w),
                  // 主题信息
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
                        // 当前主题
                        _buildInfoItem('当前主题', state.currentThemeConfig?.label ?? '默认主题'),
                        // 主题版本
                        _buildInfoItem('主题版本', 'v1.0.0'),
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

  Widget _buildInfoItem(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFEBEEF5),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.w,
              color: const Color(0xFF636E72),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.w,
              color: const Color(0xFF2D3436),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

