import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/workbench/home/bloc/bloc.dart';
import 'package:beaver/features/workbench/home/bloc/event.dart';
import 'package:beaver/features/workbench/home/bloc/state.dart';
import 'package:beaver/features/workbench/home/data/repositories/repository.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/image/image.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/api/workbench.dart';

class WorkbenchHomePage extends StatefulWidget {
  const WorkbenchHomePage({super.key});

  @override
  State<WorkbenchHomePage> createState() => _WorkbenchHomePageState();
}

class _WorkbenchHomePageState extends State<WorkbenchHomePage> {
  late WorkbenchHomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = WorkbenchHomeBloc(WorkbenchHomeRepository())
      ..add(const LoadWorkbenchHomeEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _openApp(IWorkbenchAppItem app) {
    final uri = Uri(
      path: AppRoutes.webview,
      queryParameters: {
        'url': app.entryUrl,
        'title': app.name,
      },
    );
    context.push(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<WorkbenchHomeBloc, WorkbenchHomeState>(
        listener: (context, state) {
          if (state.status == WorkbenchHomeStatus.error &&
              state.errorMessage != null) {
            BeaverToast.show(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '工作台',
            showBack: false,
            isScrollable: false,
            child: RefreshIndicator(
              onRefresh: () async {
                _bloc.add(const LoadWorkbenchHomeEvent());
                await _bloc.stream.firstWhere(
                  (s) => s.status != WorkbenchHomeStatus.loading,
                );
              },
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 24.w),
                children: [
                  _buildAppSection(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppSection(WorkbenchHomeState state) {
    if (state.status == WorkbenchHomeStatus.loading &&
        state.appList.isEmpty) {
      return SizedBox(
        height: 200.w,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.appList.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(color: const Color(0xFFEBEEF5)),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/icons/tabbar/workbench.svg',
              width: 40.w,
              height: 40.w,
            ),
            SizedBox(height: 12.w),
            Text(
              '暂无应用',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436),
              ),
            ),
            SizedBox(height: 4.w),
            Text(
              '管理员在后台配置并上架后，应用会出现在这里',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF636E72),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.w,
        childAspectRatio: 2.4,
      ),
      itemCount: state.appList.length,
      itemBuilder: (context, index) {
        return _buildAppCard(state.appList[index]);
      },
    );
  }

  Widget _buildAppCard(IWorkbenchAppItem app) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.w),
      child: InkWell(
        onTap: () => _openApp(app),
        borderRadius: BorderRadius.circular(8.w),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.w),
            border: Border.all(color: const Color(0xFFEBEEF5)),
          ),
          child: Row(
            children: [
              _buildAppIcon(app),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      app.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                    if (app.description.isNotEmpty) ...[
                      SizedBox(height: 2.w),
                      Text(
                        app.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppIcon(IWorkbenchAppItem app) {
    if (app.icon.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6.w),
        child: BeaverImage(
          url: app.icon,
          width: 36.w,
          height: 36.w,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 36.w,
      height: 36.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E8),
        borderRadius: BorderRadius.circular(6.w),
      ),
      child: Text(
        app.name.isNotEmpty ? app.name.characters.first : '?',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFFF7D45),
        ),
      ),
    );
  }
}
