import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/setting/update/bloc/bloc.dart';
import 'package:beaver/features/setting/update/bloc/event.dart';
import 'package:beaver/features/setting/update/bloc/state.dart';
import 'package:beaver/features/setting/update/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late UpdateBloc _updateBloc;

  @override
  void initState() {
    super.initState();
    _updateBloc = UpdateBloc(UpdateRepository());
  }

  @override
  void dispose() {
    _updateBloc.close();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _openUpdateModal() {
    _updateBloc.add(OpenUpdateModalEvent());
  }

  void _closeUpdateModal() {
    _updateBloc.add(CloseUpdateModalEvent());
  }

  void _downloadUpdate() {
    _updateBloc.add(DownloadUpdateEvent());
  }

  String _formatLastCheckTime(DateTime? lastCheckTime) {
    if (lastCheckTime == null) return '';
    
    final now = DateTime.now();
    final diffInMinutes = now.difference(lastCheckTime).inMinutes;
    
    if (diffInMinutes < 1) {
      return '刚刚';
    } else if (diffInMinutes < 60) {
      return '${diffInMinutes}分钟前';
    } else if (diffInMinutes < 1440) {
      return '${(diffInMinutes / 60).floor()}小时前';
    } else {
      return '${(diffInMinutes / 1440).floor()}天前';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _updateBloc,
      child: BlocConsumer<UpdateBloc, UpdateState>(
        listener: (context, state) {
          if (state.status == UpdateStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          }
        },
        builder: (context, state) {
          final updateInfo = state.updateInfo;

          return Stack(
            children: [
              BeaverLayout(
                title: '检查更新',
                showBack: true,
                showBackground: false,
                isScrollable: true,
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      // 应用信息卡片
                      Container(
                        margin: EdgeInsets.only(bottom: 32.w),
                        padding: EdgeInsets.all(32.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.w),
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
                            // 应用图标
                            Container(
                              width: 80.w,
                              height: 80.w,
                              margin: EdgeInsets.only(bottom: 16.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE6D9),
                                borderRadius: BorderRadius.circular(20.w),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.apps,
                                size: 40.w,
                                color: const Color(0xFFFF7D45),
                              ),
                            ),
                            // 应用名称
                            Text(
                              'Beaver',
                              style: TextStyle(
                                fontSize: 20.w,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3436),
                              ),
                            ),
                            SizedBox(height: 8.w),
                            // 当前版本
                            Text(
                              '当前版本 ${state.currentVersion}',
                              style: TextStyle(
                                fontSize: 14.w,
                                color: const Color(0xFFB2BEC3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 检查更新按钮
                      GestureDetector(
                        onTap: updateInfo?.isChecking == true ? null : _openUpdateModal,
                        child: Container(
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: updateInfo?.isChecking == true
                                ? const Color(0xFFE0E0E0)
                                : const Color(0xFFFF7D45),
                            borderRadius: BorderRadius.circular(24.w),
                          ),
                          alignment: Alignment.center,
                          child: updateInfo?.isChecking == true
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16.w,
                                      height: 16.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.w,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          const Color(0xFF636E72),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '检查中...',
                                      style: TextStyle(
                                        fontSize: 16.w,
                                        color: const Color(0xFF636E72),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  '检查更新',
                                  style: TextStyle(
                                    fontSize: 16.w,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      // 上次检查时间
                      if (updateInfo?.lastCheckTime != null)
                        Container(
                          margin: EdgeInsets.only(top: 16.w),
                          child: Text(
                            '上次检查：${_formatLastCheckTime(updateInfo!.lastCheckTime)}',
                            style: TextStyle(
                              fontSize: 12.w,
                              color: const Color(0xFFB2BEC3),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // 更新弹窗
              if (state.showUpdateModal)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.w),
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.w),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 检查中状态
                        if (updateInfo?.isChecking == true) ...[
                          SizedBox(
                            width: 48.w,
                            height: 48.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.w,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFFFF7D45),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.w),
                          Text(
                            '正在检查更新..',
                            style: TextStyle(
                              fontSize: 18.w,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3436),
                            ),
                          ),
                          SizedBox(height: 8.w),
                          Text(
                            '请稍候，正在获取最新版本信息',
                            style: TextStyle(
                              fontSize: 14.w,
                              color: const Color(0xFF636E72),
                            ),
                          ),
                        ],
                        // 有更新
                        if (updateInfo?.hasUpdate == true && updateInfo?.latestVersion != null) ...[
                          // 图标
                          Container(
                            margin: EdgeInsets.only(bottom: 16.w),
                            child: Icon(
                              Icons.system_update,
                              size: 48.w,
                              color: const Color(0xFFFF7D45),
                            ),
                          ),
                          // 标题
                          Text(
                            '发现新版本',
                            style: TextStyle(
                              fontSize: 18.w,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3436),
                            ),
                          ),
                          SizedBox(height: 8.w),
                          // 版本号
                          Text(
                            'v${updateInfo!.latestVersion!.version}',
                            style: TextStyle(
                              fontSize: 14.w,
                              color: const Color(0xFFFF7D45),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16.w),
                          // 版本信息
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(8.w),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '版本号：${updateInfo.latestVersion!.version}',
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    color: const Color(0xFF2D3436),
                                  ),
                                ),
                                SizedBox(height: 8.w),
                                Text(
                                  '文件大小：${updateInfo.latestVersion!.size}',
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    color: const Color(0xFF2D3436),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 更新日志
                          if (updateInfo.latestVersion!.releaseNotes.isNotEmpty) ...[
                            SizedBox(height: 16.w),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '更新内容',
                                    style: TextStyle(
                                      fontSize: 14.w,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2D3436),
                                    ),
                                  ),
                                  SizedBox(height: 8.w),
                                  Text(
                                    updateInfo.latestVersion!.releaseNotes,
                                    style: TextStyle(
                                      fontSize: 14.w,
                                      color: const Color(0xFF636E72),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          // 下载进度
                          if (updateInfo.isDownloading) ...[
                            SizedBox(height: 16.w),
                            Column(
                              children: [
                                Container(
                                  height: 8.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0E0E0),
                                    borderRadius: BorderRadius.circular(4.w),
                                  ),
                                  child: FractionallySizedBox(
                                    widthFactor: updateInfo.downloadProgress / 100,
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF7D45),
                                        borderRadius: BorderRadius.circular(4.w),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.w),
                                Text(
                                  '下载进度：${updateInfo.downloadProgress}%',
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    color: const Color(0xFF636E72),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          SizedBox(height: 24.w),
                          // 按钮
                          if (!updateInfo.isDownloading)
                            GestureDetector(
                              onTap: _downloadUpdate,
                              child: Container(
                                height: 48.w,
                                margin: EdgeInsets.only(bottom: 12.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF7D45),
                                  borderRadius: BorderRadius.circular(24.w),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.download,
                                      size: 20.w,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '立即更新',
                                      style: TextStyle(
                                        fontSize: 16.w,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          GestureDetector(
                            onTap: _closeUpdateModal,
                            child: Container(
                              height: 48.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F2F5),
                                borderRadius: BorderRadius.circular(24.w),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '稍后再说',
                                style: TextStyle(
                                  fontSize: 16.w,
                                  color: const Color(0xFF636E72),
                                ),
                              ),
                            ),
                          ),
                        ],
                        // 无更新
                        if (updateInfo?.hasUpdate == false) ...[
                          // 图标
                          Container(
                            margin: EdgeInsets.only(bottom: 16.w),
                            child: Icon(
                              Icons.check_circle,
                              size: 48.w,
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                          // 标题
                          Text(
                            '已是最新版本',
                            style: TextStyle(
                              fontSize: 18.w,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3436),
                            ),
                          ),
                          SizedBox(height: 8.w),
                          // 描述
                          Text(
                            '您当前使用的是最新版本，无需更新',
                            style: TextStyle(
                              fontSize: 14.w,
                              color: const Color(0xFF636E72),
                            ),
                          ),
                          SizedBox(height: 24.w),
                          // 按钮
                          GestureDetector(
                            onTap: _closeUpdateModal,
                            child: Container(
                              height: 48.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF7D45),
                                borderRadius: BorderRadius.circular(24.w),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '确定',
                                style: TextStyle(
                                  fontSize: 16.w,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

