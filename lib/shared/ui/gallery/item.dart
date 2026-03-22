enum GalleryItemType { image, video }

class GalleryItem {
  final String url;
  final GalleryItemType type;
  final String? thumbnail;

  GalleryItem({
    required this.url,
    required this.type,
    this.thumbnail,
  });
}
