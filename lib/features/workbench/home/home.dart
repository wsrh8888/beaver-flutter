import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:beaver/features/workbench/home/bloc/bloc.dart';
import 'package:beaver/features/workbench/home/bloc/event.dart';
import 'package:beaver/features/workbench/home/bloc/state.dart';
import 'package:beaver/features/workbench/home/data/repositories/repository.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/api/workbench.dart';
import 'package:beaver/types/cache.dart';

class WorkbenchHomePage extends StatefulWidget {
  final bool showBack;

  const WorkbenchHomePage({super.key, this.showBack = false});

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

  Future<void> _openApp(IWorkbenchAppItem app) async {
    final entry = app.resolveEntry();
    if (entry.isEmpty) {
      BeaverToast.show(context, '应用入口无效');
      return;
    }

    // 内部应用 / 路由入口
    if (app.appType == 0 || app.entryConfig.type == 0) {
      if (entry == 'moment') {
        context.push(AppRoutes.momentList);
        return;
      }
      BeaverToast.show(context, '未知内部应用：$entry');
      return;
    }

    // openMode: 1 = 系统浏览器
    if (app.openMode == 1) {
      final uri = Uri.tryParse(entry);
      if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
        BeaverToast.show(context, '应用入口地址无效');
        return;
      }
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        BeaverToast.show(context, '无法打开外部浏览器');
      }
      return;
    }

    final route = Uri(
      path: AppRoutes.webview,
      queryParameters: {
        'url': entry,
        'title': app.name,
      },
    );
    if (!mounted) return;
    context.push(route.toString());
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
            showBack: widget.showBack,
            isScrollable: false,
            child: RefreshIndicator(
              onRefresh: () async {
                _bloc.add(const LoadWorkbenchHomeEvent());
                await _bloc.stream.firstWhere(
                  (s) => s.status != WorkbenchHomeStatus.loading,
                );
              },
              child: ListView(
                padding: EdgeInsets.fromLTRB(12.w, 8.w, 12.w, 24.w),
                children: _buildAppSections(state),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildAppSections(WorkbenchHomeState state) {
    if (state.status == WorkbenchHomeStatus.loading && state.isEmpty) {
      return [
        SizedBox(
          height: 200.w,
          child: const Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (state.isEmpty) {
      return [
        Container(
          margin: EdgeInsets.only(top: 40.w),
          padding: EdgeInsets.all(24.w),
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
        ),
      ];
    }

    final widgets = <Widget>[];
    for (final group in state.groups) {
      if (group.list.isEmpty) continue;
      if (widgets.isNotEmpty) {
        widgets.add(SizedBox(height: 12.w));
      }
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 20.w),
          child: Text(
            group.categoryName,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF636E72),
            ),
          ),
        ),
      );
      widgets.add(
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.w,
            childAspectRatio: 0.88,
          ),
          itemCount: group.list.length,
          itemBuilder: (context, index) {
            return _buildAppTile(group.list[index]);
          },
        ),
      );
    }
    return widgets;
  }

  Widget _buildAppTile(IWorkbenchAppItem app) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openApp(app),
        borderRadius: BorderRadius.circular(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BeaverCachedImage(
              fileUrl: app.icon,
              type: CacheType.image,
              width: 48.w,
              height: 48.w,
              borderRadius: 12.w,
            ),
            SizedBox(height: 4.w),
            Text(
              app.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.2,
                color: const Color(0xFF2D3436),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
