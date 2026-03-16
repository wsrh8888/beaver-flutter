abstract class MomentEvent {
  const MomentEvent();
}

class LoadMomentsEvent extends MomentEvent {
  const LoadMomentsEvent();
}

class ToggleLikeEvent extends MomentEvent {
  final String momentId;
  final bool status;

  const ToggleLikeEvent(this.momentId, this.status);
}

class PreviewImageEvent extends MomentEvent {
  final List<String> images;
  final int currentIndex;

  const PreviewImageEvent(this.images, this.currentIndex);
}

class GoToPostEvent extends MomentEvent {
  const GoToPostEvent();
}
