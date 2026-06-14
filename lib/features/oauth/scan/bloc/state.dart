import 'package:equatable/equatable.dart';

enum OAuthScanConfirmStatus { initial, loading, ready, submitting, success, error }

class OAuthScanConfirmState extends Equatable {
  final OAuthScanConfirmStatus status;
  final String sceneId;
  final String appName;
  final String appIcon;
  final List<String> scopes;
  final String? errorMessage;

  const OAuthScanConfirmState({
    this.status = OAuthScanConfirmStatus.initial,
    this.sceneId = '',
    this.appName = '',
    this.appIcon = '',
    this.scopes = const [],
    this.errorMessage,
  });

  OAuthScanConfirmState copyWith({
    OAuthScanConfirmStatus? status,
    String? sceneId,
    String? appName,
    String? appIcon,
    List<String>? scopes,
    String? errorMessage,
  }) {
    return OAuthScanConfirmState(
      status: status ?? this.status,
      sceneId: sceneId ?? this.sceneId,
      appName: appName ?? this.appName,
      appIcon: appIcon ?? this.appIcon,
      scopes: scopes ?? this.scopes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sceneId, appName, appIcon, scopes, errorMessage];
}
