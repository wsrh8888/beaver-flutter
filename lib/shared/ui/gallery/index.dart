import 'package:flutter/material.dart';
import '../image/image.dart';

class BeaverGallery extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;

  const BeaverGallery({
    super.key,
    required this.urls,
    this.initialIndex = 0,
  });

  @override
  State<BeaverGallery> createState() => _BeaverGalleryState();

  static void show(BuildContext context, String url, {List<String>? urls}) {
    final List<String> allUrls = urls ?? [url];
    final int index = allUrls.indexOf(url);
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => BeaverGallery(
          urls: allUrls,
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

  void _showActionSheet(String url) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('下载'),
              onTap: () {
                // TODO: Implement download logic
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.forward),
              title: const Text('转发'),
              onTap: () {
                // TODO: Implement forward logic
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('收藏'),
              onTap: () {
                // TODO: Implement favorite logic
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.urls.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final url = widget.urls[index];
              return GestureDetector(
                onLongPress: () => _showActionSheet(url),
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: BeaverImage(
                      url: url,
                      fit: BoxFit.contain,
                      enableFullscreen: false,
                    ),
                  ),
                ),
              );
            },
          ),
          // 关闭按钮
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // 页码指示
          if (widget.urls.length > 1)
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
                    '${_currentIndex + 1} / ${widget.urls.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
