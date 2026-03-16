abstract class UpdateEvent {
  const UpdateEvent();
}

class CheckUpdateEvent extends UpdateEvent {
  const CheckUpdateEvent();
}

class OpenUpdateModalEvent extends UpdateEvent {
  const OpenUpdateModalEvent();
}

class CloseUpdateModalEvent extends UpdateEvent {
  const CloseUpdateModalEvent();
}

class DownloadUpdateEvent extends UpdateEvent {
  const DownloadUpdateEvent();
}
