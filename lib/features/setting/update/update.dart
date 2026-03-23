import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/setting/update/bloc/bloc.dart';
import 'package:beaver/features/setting/update/bloc/event.dart';
import 'package:beaver/features/setting/update/bloc/state.dart';
import 'package:beaver/features/setting/update/data/repositories/repository.dart';
import 'package:beaver/features/setting/update/data/models/update.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> with TickerProviderStateMixin {
  late UpdateBloc _updateBloc;
  late AnimationController _refreshIconController;

  @override
  void initState() {
    super.initState();
    _updateBloc = UpdateBloc(UpdateRepository());
    _refreshIconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _updateBloc.close();
    _refreshIconController.dispose();
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
          if (state.updateInfo?.isChecking == true) {
            _refreshIconController.repeat();
          } else {
            _refreshIconController.stop();
          }
        },
        builder: (context, state) {
          final updateInfo = state.updateInfo;
          final isChecking = updateInfo?.isChecking ?? false;

          return BeaverLayout(
            title: '检查更新',
            showBack: true,
            onBack: _goBack,
            showBackground: false,
            isScrollable: true,
            child: Stack(
              children: [
                // 页面主内容
                SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      // 应用信息卡片
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(32.w),
                        margin: EdgeInsets.only(bottom: 24.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: Offset(0, 4.w),
                              blurRadius: 20.w,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Logo
                            Container(
                              width: 80.w, // 160rpx
                              height: 80.w,
                              margin: EdgeInsets.only(bottom: 16.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.w),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.w),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 80.w,
                                  height: 80.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // App Name
                            Text(
                              'Beaver',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3436),
                              ),
                            ),
                            SizedBox(height: 8.w),
                            // Current Version
                            Text(
                              '当前版本 ${state.currentVersion}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF636E72),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // 检查更新区域
                      Column(
                        children: [
                          GestureDetector(
                            onTap: isChecking ? null : _openUpdateModal,
                            child: Container(
                              width: double.infinity,
                              height: 48.w,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF7D45).withOpacity(0.3),
                                    offset: Offset(0, 4.w),
                                    blurRadius: 16.w,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: isChecking
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        RotationTransition(
                                          turns: _refreshIconController,
                                          child: SvgPicture.asset(
                                            'assets/images/update/refresh.svg',
                                            width: 18.w,
                                            height: 18.w,
                                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          '检查中...',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      '检查更新',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                          
                          if (updateInfo?.lastCheckTime != null)
                            Padding(
                              padding: EdgeInsets.only(top: 16.w),
                              child: Text(
                                '上次检查：${_formatLastCheckTime(updateInfo!.lastCheckTime)}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFFB2BEC3),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 弹窗遮罩
                if (state.showUpdateModal)
                  GestureDetector(
                    onTap: (updateInfo?.isDownloading ?? false) ? null : _closeUpdateModal,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      padding: EdgeInsets.all(24.w),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {}, // 阻止冒泡
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(maxWidth: 320.w),
                          padding: EdgeInsets.all(32.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 8.w),
                                blurRadius: 32.w,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 检查中状态
                              if (isChecking)
                                _buildCheckingStatus()
                              // 有更新
                              else if (updateInfo?.hasUpdate == true && updateInfo != null)
                                _buildHasUpdateStatus(updateInfo)
                              // 无更新
                              else
                                _buildNoUpdateStatus(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCheckingStatus() {
    return Column(
      children: [
        RotationTransition(
          turns: _refreshIconController,
          child: SvgPicture.asset(
            'assets/images/update/refresh.svg',
            width: 32.w,
            height: 32.w,
            colorFilter: const ColorFilter.mode(Color(0xFFFF7D45), BlendMode.srcIn),
          ),
        ),
        SizedBox(height: 16.w),
        Text(
          '正在检查更新...',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        SizedBox(height: 8.w),
        Text(
          '请稍候，正在获取最新版本信息',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF636E72),
          ),
        ),
      ],
    );
  }

  Widget _buildHasUpdateStatus(UpdateInfo updateInfo) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '发现新版本',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                'v${updateInfo.latestVersion?.version}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFFF7D45),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.w),
        _buildDetailItem('版本号：', updateInfo.latestVersion?.version ?? ''),
        _buildDetailItem('文件大小：', updateInfo.latestVersion?.size ?? '0MB'),
        
        if (updateInfo.latestVersion?.releaseNotes.isNotEmpty ?? false) ...[
          SizedBox(height: 24.w),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '更新内容',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                SizedBox(height: 8.w),
                Text(
                  updateInfo.latestVersion!.releaseNotes,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF636E72),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
        
        if (updateInfo.isDownloading) ...[
          SizedBox(height: 24.w),
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 6.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: FractionallySizedBox(
                  widthFactor: updateInfo.downloadProgress / 100,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
                      ),
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.w),
              Text(
                '下载中 ${updateInfo.downloadProgress}%',
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF636E72)),
              ),
            ],
          ),
        ],
        
        SizedBox(height: 24.w),
        Row(
          children: [
            if (!updateInfo.isDownloading)
              Expanded(
                child: GestureDetector(
                  onTap: _downloadUpdate,
                  child: Container(
                    height: 40.w,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
                      ),
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/update/download.svg',
                          width: 14.w,
                          height: 14.w,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '立即更新',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: GestureDetector(
                onTap: updateInfo.isDownloading ? null : _closeUpdateModal,
                child: Container(
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFEBEEF5)),
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    updateInfo.isDownloading ? '下载中...' : '稍后再说',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF636E72),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNoUpdateStatus() {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/update/check.svg',
          width: 48.w,
          height: 48.w,
        ),
        SizedBox(height: 16.w),
        Text(
          '已是最新版本',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        SizedBox(height: 8.w),
        Text(
          '您当前使用的是最新版本，无需更新',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF636E72),
          ),
        ),
        SizedBox(height: 24.w),
        GestureDetector(
          onTap: _closeUpdateModal,
          child: Container(
            width: double.infinity,
            height: 40.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
              ),
              borderRadius: BorderRadius.circular(20.w),
            ),
            alignment: Alignment.center,
            child: Text(
              '确定',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF636E72))),
          Text(value, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF2D3436), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
