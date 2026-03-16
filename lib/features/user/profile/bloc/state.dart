import 'package:beaver/features/user/profile/data/models/profile.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState {
  final ProfileStatus status;
  final UserInfo? userInfo;
  final Map<String, bool> modals;
  final Map<String, dynamic> formData;
  final int countdown;
  final bool isCodeSending;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.userInfo,
    this.modals = const {
      'nickname': false,
      'email': false,
      'description': false,
      'gender': false,
    },
    this.formData = const {},
    this.countdown = 0,
    this.isCodeSending = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserInfo? userInfo,
    Map<String, bool>? modals,
    Map<String, dynamic>? formData,
    int? countdown,
    bool? isCodeSending,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userInfo: userInfo ?? this.userInfo,
      modals: modals ?? this.modals,
      formData: formData ?? this.formData,
      countdown: countdown ?? this.countdown,
      isCodeSending: isCodeSending ?? this.isCodeSending,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

