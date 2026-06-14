import 'package:beaver/api/auth.dart';
import 'package:beaver/common/config/config.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginDevicesPage extends StatefulWidget {
  const LoginDevicesPage({super.key});

  @override
  State<LoginDevicesPage> createState() => _LoginDevicesPageState();
}

class _LoginDevicesPageState extends State<LoginDevicesPage> {
  List<DeviceInfo> _devices = [];
  bool _isLoading = true;
  String? _kickingDeviceId;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() => _isLoading = true);
    try {
      final res = await getDevicesApi();
      if (!mounted) {
        return;
      }
      if (res.isSuccess && res.result != null) {
        setState(() {
          _devices = res.result!.devices;
          _isLoading = false;
        });
        return;
      }
      setState(() => _isLoading = false);
      BeaverToast.show(context, res.msg.isNotEmpty ? res.msg : '获取设备列表失败');
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
        BeaverToast.show(context, '获取设备列表失败');
      }
    }
  }

  bool _isCurrentDevice(String deviceId) => deviceId == AppConfig.deviceId;

  String _formatDeviceMeta(DeviceInfo device) {
    final osLabel = device.deviceOsVersion.isNotEmpty
        ? '${device.deviceOs} ${device.deviceOsVersion}'
        : device.deviceOs;
    return [
      device.deviceModel,
      osLabel,
      device.lastLoginIp,
    ].where((item) => item.isNotEmpty).join(' · ');
  }

  Future<void> _handleKick(DeviceInfo device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('踢下线'),
        content: Text(
          '确定要将「${device.deviceName.isNotEmpty ? device.deviceName : '该设备'}」踢下线吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }

    setState(() => _kickingDeviceId = device.deviceId);
    try {
      final res = await kickDeviceApi(KickDeviceReq(deviceId: device.deviceId));
      if (!mounted) {
        return;
      }
      if (res.isSuccess) {
        BeaverToast.show(context, '已踢下线');
        await _loadDevices();
        return;
      }
      BeaverToast.show(context, res.msg.isNotEmpty ? res.msg : '操作失败');
    } catch (_) {
      if (mounted) {
        BeaverToast.show(context, '操作失败');
      }
    } finally {
      if (mounted) {
        setState(() => _kickingDeviceId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '登录设备管理',
      showBack: true,
      showBackground: true,
      backgroundType: 'gradient',
      backgroundHeight: 60,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '查看并管理已登录的设备，可将其他在线设备踢下线。',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFFB2BEC3),
                height: 1.5,
              ),
            ),
            SizedBox(height: 16.w),
            if (_isLoading)
              _buildStatusCard('加载中...')
            else if (_devices.isEmpty)
              _buildStatusCard('暂无登录设备')
            else
              _buildDeviceCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 48.w),
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
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFFB2BEC3)),
      ),
    );
  }

  Widget _buildDeviceCard() {
    return Container(
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: List.generate(_devices.length, (index) {
          final device = _devices[index];
          final isCurrent = _isCurrentDevice(device.deviceId);
          final canKick = !isCurrent && device.isOnline;

          return Container(
            padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 16.w),
            decoration: BoxDecoration(
              border: index < _devices.length - 1
                  ? Border(
                      bottom: BorderSide(
                        color: const Color(0xFFEBEEF5),
                        width: 1.w,
                      ),
                    )
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              device.deviceName.isNotEmpty
                                  ? device.deviceName
                                  : '未知设备',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2D3436),
                              ),
                            ),
                          ),
                          if (isCurrent) ...[
                            SizedBox(width: 8.w),
                            _buildTag('本机', const Color(0xFFFF7D45)),
                          ] else if (device.isOnline) ...[
                            SizedBox(width: 8.w),
                            _buildTag('在线', const Color(0xFF00B894)),
                          ],
                        ],
                      ),
                      if (_formatDeviceMeta(device).isNotEmpty) ...[
                        SizedBox(height: 4.w),
                        Text(
                          _formatDeviceMeta(device),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFFB2BEC3),
                          ),
                        ),
                      ],
                      if (device.lastLoginTime.isNotEmpty) ...[
                        SizedBox(height: 4.w),
                        Text(
                          '最近登录：${device.lastLoginTime}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFFB2BEC3),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (canKick)
                  TextButton(
                    onPressed: _kickingDeviceId == device.deviceId
                        ? null
                        : () => _handleKick(device),
                    child: _kickingDeviceId == device.deviceId
                        ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            '踢下线',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFFFF7D45),
                            ),
                          ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11.sp, color: color),
      ),
    );
  }
}
