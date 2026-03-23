import 'package:beaver/core/business/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/shared/ui/gallery/index.dart';
import 'package:beaver/shared/ui/gallery/item.dart';
import 'package:beaver/shared/ui/cache/video.dart';
import 'package:beaver/types/business/message.dart';
import 'package:beaver/types/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoMessage extends StatelessWidget {
  final VideoMsg msg;
  const VideoMessage({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    print(
      '[VideoMessage] Build: msg.fileKey=${msg.fileKey}, msg.thumbnailKey=${msg.thumbnailKey}, msg.width=${msg.width}, msg.height=${msg.height}',
    );
    final size = _calculateDisplaySize(
      (msg.width ?? 160).toDouble(),
      (msg.height ?? 120).toDouble(),
    );

    return BeaverCachedVideo(
      videoKey: msg.fileKey,
      thumbnailKey: msg.thumbnailKey,
      width: size.width,
      height: size.height,
      borderRadius: 8.w,
      fit: BoxFit.cover,
      duration: msg.duration,
      onTap: () async {
        print('[VideoMessage] Tapped: videoKey=${msg.fileKey}');
        final mediaBusiness = getIt<MediaBusiness>();
        final url = await mediaBusiness.getMediaPath(
          msg.fileKey,
          CacheType.video,
        );
        if (context.mounted) {
          BeaverGallery.show(
            context,
            GalleryItem(
              url: url,
              type: GalleryItemType.video,
              thumbnail: msg.thumbnailKey,
            ),
          );
        }
      },
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
    final double scaleRatio = widthRatio < heightRatio
        ? widthRatio
        : heightRatio;

    return Size(originalWidth * scaleRatio, originalHeight * scaleRatio);
  }
}
