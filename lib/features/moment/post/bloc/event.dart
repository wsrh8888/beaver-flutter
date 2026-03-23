abstract class PostMomentEvent {
  const PostMomentEvent();
}

class UpdateContentEvent extends PostMomentEvent {
  final String content;

  const UpdateContentEvent(this.content);
}

class AddImageEvent extends PostMomentEvent {
  final String imagePath;

  const AddImageEvent(this.imagePath);
}

class RemoveImageEvent extends PostMomentEvent {
  final int index;

  const RemoveImageEvent(this.index);
}

class PreviewImageEvent extends PostMomentEvent {
  final int index;

  const PreviewImageEvent(this.index);
}

class PostMomentSubmitEvent extends PostMomentEvent {
  const PostMomentSubmitEvent();
}
