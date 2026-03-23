import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BeaverVideoPlayer extends StatefulWidget {
  final String url;
  final bool autoPlay;

  const BeaverVideoPlayer({
    super.key,
    required this.url,
    this.autoPlay = true,
  });

  @override
  State<BeaverVideoPlayer> createState() => _BeaverVideoPlayerState();
}

class _BeaverVideoPlayerState extends State<BeaverVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    try {
      if (widget.url.startsWith('file://')) {
        final path = widget.url.replaceFirst('file://', '');
        _controller = VideoPlayerController.file(File(path));
      } else if (widget.url.startsWith('http')) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      } else {
        throw Exception('Unsupported video URL: ${widget.url}');
      }

      await _controller.initialize();
      if (widget.autoPlay) {
        await _controller.play();
      }
      if (mounted) {
        setState(() => _initialized = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Text(
          '播放错误: $_error',
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          if (!_controller.value.isPlaying)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 48),
            ),
          // Simple progress bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Color(0xFFFF7D45),
                bufferedColor: Colors.white24,
                backgroundColor: Colors.white10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
