enum GalleryItemType { image, video }

class GalleryItem {
  final String url;
  final GalleryItemType type;
  final String? thumbnail;
  final String? messageId;
  final String? sourceFileUrl;

  GalleryItem({
    required this.url,
    required this.type,
    this.thumbnail,
    this.messageId,
    this.sourceFileUrl,
  });

  String get remoteFileUrl => sourceFileUrl ?? url;
}
