import 'package:beaver/core/business/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/shared/ui/gallery/index.dart';
import 'package:beaver/shared/ui/gallery/item.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/types/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageMessage extends StatelessWidget {
  final ImageMsg msg;
  final String? messageId;

  const ImageMessage({
    super.key,
    required this.msg,
    this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    final size = _calculateDisplaySize(
      (msg.width ?? 200).toDouble(),
      (msg.height ?? 200).toDouble(),
    );

    return GestureDetector(
      onTap: () => _openGallery(context),
      child: BeaverCachedImage(
        fileUrl: msg.fileUrl,
        type: CacheType.image,
        width: size.width,
        height: size.height,
        borderRadius: 8.w,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<void> _openGallery(BuildContext context) async {
    final mediaBusiness = getIt<MediaBusiness>();
    final url = await mediaBusiness.getMediaPath(msg.fileUrl, CacheType.image);
    if (!context.mounted) {
      return;
    }
    BeaverGallery.show(
      context,
      GalleryItem(
        url: url,
        sourceFileUrl: msg.fileUrl,
        type: GalleryItemType.image,
        messageId: messageId,
      ),
    );
  }

  Size _calculateDisplaySize(double originalWidth, double originalHeight) {
    final double maxWidth = 200.w;
    final double maxHeight = 300.w;

    if (originalWidth <= maxWidth && originalHeight <= maxHeight) {
      return Size(originalWidth, originalHeight);
    }

    final double widthRatio = maxWidth / originalWidth;
    final double heightRatio = maxHeight / originalHeight;
    final double scaleRatio = widthRatio < heightRatio ? widthRatio : heightRatio;

    return Size(originalWidth * scaleRatio, originalHeight * scaleRatio);
  }
}
