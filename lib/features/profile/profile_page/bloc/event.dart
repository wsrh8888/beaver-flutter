abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadUserInfoEvent extends ProfileEvent {
  const LoadUserInfoEvent();
}

class OpenModalEvent extends ProfileEvent {
  final String modalType;

  const OpenModalEvent(this.modalType);
}

class CloseModalEvent extends ProfileEvent {
  final String modalType;

  const CloseModalEvent(this.modalType);
}

class UpdateFormDataEvent extends ProfileEvent {
  final String key;
  final dynamic value;

  const UpdateFormDataEvent(this.key, this.value);
}

class SaveNicknameEvent extends ProfileEvent {
  const SaveNicknameEvent();
}

class SaveEmailEvent extends ProfileEvent {
  const SaveEmailEvent();
}

class SaveBioEvent extends ProfileEvent {
  const SaveBioEvent();
}

class SaveGenderEvent extends ProfileEvent {
  const SaveGenderEvent();
}

class SendEmailCodeEvent extends ProfileEvent {
  const SendEmailCodeEvent();
}

class UpdateAvatarEvent extends ProfileEvent {
  const UpdateAvatarEvent();
}
