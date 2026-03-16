import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/discover/discover_page/bloc/bloc.dart';
import 'package:beaver/features/discover/discover_page/bloc/event.dart';
import 'package:beaver/features/discover/discover_page/bloc/state.dart';
import 'package:beaver/features/discover/discover_page/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late DiscoverBloc _discoverBloc;

  @override
  void initState() {
    super.initState();
    _discoverBloc = DiscoverBloc(DiscoverRepository())..add(LoadDiscoverItemsEvent());
  }

  @override
  void dispose() {
    _discoverBloc.close();
    super.dispose();
  }

  void _navigateTo(String route) {
    _discoverBloc.add(NavigateToEvent(route));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _discoverBloc,
      child: BlocConsumer<DiscoverBloc, DiscoverState>(
        listener: (context, state) {
          if (state.status == DiscoverStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '发现',
            showBack: false,
            showBackground: false,
            isScrollable: true,
            child: Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // 发现项目网格
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.w,
                      mainAxisSpacing: 20.w,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: state.discoverItems.length,
                    itemBuilder: (context, index) {
                      final item = state.discoverItems[index];
                      return GestureDetector(
                        onTap: () => _navigateTo(item.route),
                        child: Container(
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
                          padding: EdgeInsets.all(24.w),
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
                                  _getIconForItem(item.icon),
                                  size: 32.w,
                                  color: const Color(0xFFFF7D45),
                                ),
                              ),
                              // 标题
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 16.w,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3436),
                                ),
                              ),
                              SizedBox(height: 8.w),
                              // 描述
                              Text(
                                item.description,
                                style: TextStyle(
                                  fontSize: 12.w,
                                  color: const Color(0xFF636E72),
                                ),
                                textAlign: TextAlign.center,
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
          );
        },
      ),
    );
  }

  IconData _getIconForItem(String icon) {
    switch (icon) {
      case 'nearby':
        return Icons.location_on;
      case 'group':
        return Icons.group;
      case 'scan':
        return Icons.qr_code_scanner;
      case 'moment':
        return Icons.photo_library;
      default:
        return Icons.star;
    }
  }
}
