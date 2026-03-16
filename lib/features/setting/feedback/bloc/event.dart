abstract class FeedbackEvent {
  const FeedbackEvent();
}

class LoadFeedbackTypesEvent extends FeedbackEvent {
  const LoadFeedbackTypesEvent();
}

class SelectFeedbackTypeEvent extends FeedbackEvent {
  final int type;

  const SelectFeedbackTypeEvent(this.type);
}

class UpdateContentEvent extends FeedbackEvent {
  final String content;

  const UpdateContentEvent(this.content);
}

class AddImageEvent extends FeedbackEvent {
  final UploadedImage image;

  const AddImageEvent(this.image);
}

class RemoveImageEvent extends FeedbackEvent {
  final int index;

  const RemoveImageEvent(this.index);
}

class SubmitFeedbackEvent extends FeedbackEvent {
  const SubmitFeedbackEvent();
}
