abstract class DetailEvent {
  const DetailEvent();
}

class LoadUserInfoEvent extends DetailEvent {
  final String userId;

  const LoadUserInfoEvent(this.userId);
}

class ToggleMoreMenuEvent extends DetailEvent {
  const ToggleMoreMenuEvent();
}

class ShowEditNoteDialogEvent extends DetailEvent {
  const ShowEditNoteDialogEvent();
}

class CloseEditNoteDialogEvent extends DetailEvent {
  const CloseEditNoteDialogEvent();
}

class SaveRemarkNameEvent extends DetailEvent {
  final String remarkName;

  const SaveRemarkNameEvent(this.remarkName);
}

class DeleteFriendEvent extends DetailEvent {
  const DeleteFriendEvent();
}

class SendMessageEvent extends DetailEvent {
  const SendMessageEvent();
}

class ClearNavigationEvent extends DetailEvent {
  const ClearNavigationEvent();
}

class AudioCallEvent extends DetailEvent {
  const AudioCallEvent();
}

class VideoCallEvent extends DetailEvent {
  const VideoCallEvent();
}
