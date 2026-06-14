import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:beaver/features/oauth/scan/bloc/bloc.dart';
import 'package:beaver/features/oauth/scan/bloc/event.dart';
import 'package:beaver/features/oauth/scan/bloc/state.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/button/index.dart';
import 'package:beaver/shared/ui/image/image.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/theme/colors.dart';

class OAuthScanConfirmPage extends StatelessWidget {
  final String sceneId;

  const OAuthScanConfirmPage({super.key, required this.sceneId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OAuthScanConfirmBloc()..add(OAuthScanConfirmInitEvent(sceneId)),
      child: OAuthScanConfirmView(sceneId: sceneId),
    );
  }
}

class OAuthScanConfirmView extends StatelessWidget {
  final String sceneId;

  const OAuthScanConfirmView({super.key, required this.sceneId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OAuthScanConfirmBloc, OAuthScanConfirmState>(
      listener: (context, state) {
        if (state.status == OAuthScanConfirmStatus.success) {
          BeaverToast.show(context, '登录成功');
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        } else if (state.status == OAuthScanConfirmStatus.error && state.errorMessage != null) {
          BeaverToast.show(context, state.errorMessage!);
        } else if (state.status == OAuthScanConfirmStatus.ready && state.errorMessage != null) {
          BeaverToast.show(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return BeaverLayout(
          title: '登录确认',
          showBack: true,
          showBackground: true,
          isScrollable: false,
          onBack: () => _handleCancel(context),
          child: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, OAuthScanConfirmState state) {
    if (state.status == OAuthScanConfirmStatus.loading ||
        state.status == OAuthScanConfirmStatus.initial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.status == OAuthScanConfirmStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? '二维码无效',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
      );
    }

    final submitting = state.status == OAuthScanConfirmStatus.submitting;
    final appName = state.appName.isNotEmpty ? state.appName : '第三方应用';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 56.w),
          _buildAppIcon(state.appIcon),
          SizedBox(height: 24.w),
          Text(
            appName,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
              height: 1.3,
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            '网页版登录确认',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: BeaverButton(
              text: submitting ? '登录中...' : '登录',
              loading: submitting,
              disabled: submitting,
              onPressed: submitting
                  ? null
                  : () => context.read<OAuthScanConfirmBloc>().add(
                        const OAuthScanConfirmSubmitEvent(),
                      ),
            ),
          ),
          SizedBox(height: 16.w),
          TextButton(
            onPressed: submitting ? null : () => _handleCancel(context),
            child: Text(
              '取消登录',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 32.w),
        ],
      ),
    );
  }

  Widget _buildAppIcon(String icon) {
    final size = 80.w;
    final radius = 16.w;

    if (icon.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BeaverImage(
          url: icon,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    if (icon.isNotEmpty) {
      return BeaverAvatar(
        size: 80,
        avatar: icon,
        borderRadius: radius,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  void _handleCancel(BuildContext context) {
    context.read<OAuthScanConfirmBloc>().add(const OAuthScanConfirmCancelEvent());
    if (context.canPop()) {
      context.pop();
    }
  }
}
