import 'package:beaver/features/about/about_page/data/models/app_info.dart';

enum AboutStatus { initial, loading, success, error }

class AboutState {
  final AboutStatus status;
  final AppInfo? appInfo;
  final String? errorMessage;

  const AboutState({
    this.status = AboutStatus.initial,
    this.appInfo,
    this.errorMessage,
  });

  AboutState copyWith({
    AboutStatus? status,
    AppInfo? appInfo,
    String? errorMessage,
  }) {
    return AboutState(
      status: status ?? this.status,
      appInfo: appInfo ?? this.appInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
