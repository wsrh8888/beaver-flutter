class FeedbackType {
  final int value;
  final String label;

  const FeedbackType({
    required this.value,
    required this.label,
  });
}

class UploadedImage {
  final String fileName;
  final String name;

  const UploadedImage({
    required this.fileName,
    required this.name,
  });
}
