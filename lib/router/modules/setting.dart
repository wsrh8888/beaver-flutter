import 'package:go_router/go_router.dart';
import 'package:beaver/features/setting/account_security/account_security.dart';
import 'package:beaver/features/setting/account_security/change_password.dart';
import 'package:beaver/features/setting/account_security/devices.dart';
import 'package:beaver/features/setting/main/main.dart';
import 'package:beaver/features/setting/theme/theme.dart';
import 'package:beaver/features/setting/about/about.dart';
import 'package:beaver/features/setting/feedback/feedback.dart';
import 'package:beaver/features/setting/privacy/privacy.dart';
import 'package:beaver/features/setting/agreement/agreement.dart';
import 'package:beaver/features/setting/disclaimer/disclaimer.dart';
import 'package:beaver/features/setting/update/update.dart';
import 'package:beaver/router/routes.dart';

List<GoRoute> settingRoutes() {
  return [
    GoRoute(
      path: AppRoutes.settingMain,
      builder: (context, state) => const SettingMainPage(),
    ),
    GoRoute(
      path: AppRoutes.settingAccountSecurity,
      builder: (context, state) => const AccountSecurityPage(),
    ),
    GoRoute(
      path: AppRoutes.settingChangePassword,
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.settingDevices,
      builder: (context, state) => const LoginDevicesPage(),
    ),
    GoRoute(
      path: AppRoutes.settingTheme,
      builder: (context, state) => const ThemePage(),
    ),
    GoRoute(
      path: AppRoutes.settingAbout,
      builder: (context, state) => const AboutPage(),
    ),
    GoRoute(
      path: AppRoutes.settingFeedback,
      builder: (context, state) => const FeedbackPage(),
    ),
    GoRoute(
      path: AppRoutes.settingPrivacy,
      builder: (context, state) => const PrivacyPage(),
    ),
    GoRoute(
      path: AppRoutes.settingAgreement,
      builder: (context, state) => const AgreementPage(),
    ),
    GoRoute(
      path: AppRoutes.settingDisclaimer,
      builder: (context, state) => const DisclaimerPage(),
    ),
    GoRoute(
      path: AppRoutes.settingUpdate,
      builder: (context, state) => const UpdatePage(),
    ),
  ];
}
