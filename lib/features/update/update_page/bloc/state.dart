import 'package:beaver/features/update/update_page/data/models/update.dart';

enum UpdateStatus { initial, loading, success, error }

class UpdateState {
  final UpdateStatus status;
  final String currentVersion;
  final UpdateInfo? updateInfo;
  final bool showUpdateModal;
  final String? errorMessage;

  const UpdateState({
    this.status = UpdateStatus.initial,
    this.currentVersion = '1.0.0',
    this.updateInfo,
    this.showUpdateModal = false,
    this.errorMessage,
  });

  UpdateState copyWith({
    UpdateStatus? status,
    String? currentVersion,
    UpdateInfo? updateInfo,
    bool? showUpdateModal,
    String? errorMessage,
  }) {
    return UpdateState(
      status: status ?? this.status,
      currentVersion: currentVersion ?? this.currentVersion,
      updateInfo: updateInfo ?? this.updateInfo,
      showUpdateModal: showUpdateModal ?? this.showUpdateModal,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
