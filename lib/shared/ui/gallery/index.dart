import 'dart:io';

import 'package:beaver/api/emoji.dart';
import 'package:beaver/core/cache/media_manager.dart';
import 'package:beaver/features/chat/detail/components/content/handler/forward.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/cache.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import '../image/image.dart';
import '../video/player.dart';
import 'item.dart';

class BeaverGallery extends StatefulWidget {
  final List<GalleryItem> items;
  final int initialIndex;

  const BeaverGallery({super.key, required this.items, this.initialIndex = 0});

  @override
  State<BeaverGallery> createState() => _BeaverGalleryState();

  static void show(
    BuildContext context,
    GalleryItem item, {
    List<GalleryItem>? items,
  }) {
    final List<GalleryItem> allItems = items ?? [item];
    final int index = allItems.indexWhere((i) => i.url == item.url);
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BeaverGallery(
          items: allItems,
          initialIndex: index >= 0 ? index : 0,
        ),
      ),
    );
  }
}

class _BeaverGalleryState extends State<BeaverGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  GalleryItem get _currentItem => widget.items[_currentIndex];

  void _showActionSheet(GalleryItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('下载'),
              onTap: () async {
                Navigator.pop(context);
                await _downloadItem(item);
              },
            ),
            if (item.messageId != null)
              ListTile(
                leading: const Icon(Icons.forward),
                title: const Text('转发'),
                onTap: () {
                  Navigator.pop(context);
                  ForwardHandler.navigateToPicker(
                    context,
                    messageIds: [item.messageId!],
                  );
                },
              ),
            if (item.type == GalleryItemType.image)
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('收藏'),
                onTap: () async {
                  Navigator.pop(context);
                  await _favoriteImage(item);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadItem(GalleryItem item) async {
    final cacheType = item.type == GalleryItemType.video
        ? CacheType.video
        : CacheType.image;
    final localPath = await MediaManager().add(cacheType, item.remoteFileUrl);
    if (localPath == null || localPath.isEmpty) {
      if (mounted) {
        BeaverToast.show(context, '下载失败', type: ToastType.error);
      }
      return;
    }

    final filePath = localPath.startsWith('file://')
        ? localPath.substring(7)
        : localPath;

    if (item.type == GalleryItemType.image) {
      final bytes = await File(filePath).readAsBytes();
      final result = await ImageGallerySaverPlus.saveImage(bytes, quality: 100);
      if (mounted) {
        final ok = result != null && result['isSuccess'] == true;
        BeaverToast.show(
          context,
          ok ? '已保存到相册' : '保存失败',
          type: ok ? ToastType.success : ToastType.error,
        );
      }
      return;
    }

    final result = await ImageGallerySaverPlus.saveFile(filePath);
    if (mounted) {
      final ok = result != null && result['isSuccess'] == true;
      BeaverToast.show(
        context,
        ok ? '已保存到相册' : '保存失败',
        type: ok ? ToastType.success : ToastType.error,
      );
    }
  }

  Future<void> _favoriteImage(GalleryItem item) async {
    final res = await addEmojiApi({
      'fileKey': item.remoteFileUrl,
      'title': '来自聊天',
    });
    if (!mounted) {
      return;
    }
    if (res.code == 0) {
      BeaverToast.show(context, '已添加到表情', type: ToastType.success);
    } else {
      BeaverToast.show(context, res.msg, type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return _buildItem(item);
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.white, size: 30),
              onPressed: () => _showActionSheet(_currentItem),
            ),
          ),
          if (widget.items.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.items.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItem(GalleryItem item) {
    if (item.type == GalleryItemType.video) {
      return GestureDetector(
        onLongPress: () => _showActionSheet(item),
        child: BeaverVideoPlayer(url: item.url),
      );
    }

    return GestureDetector(
      onLongPress: () => _showActionSheet(item),
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: BeaverImage(
            url: item.url,
            fit: BoxFit.contain,
            enableFullscreen: false,
          ),
        ),
      ),
    );
  }
}
