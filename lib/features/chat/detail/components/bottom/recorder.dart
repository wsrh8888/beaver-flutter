import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRecorder extends StatefulWidget {
  const ChatRecorder({super.key});
  @override
  State<ChatRecorder> createState() => _ChatRecorderState();
}

class _ChatRecorderState extends State<ChatRecorder> {
  bool _isRecording = false;
  int _seconds = 0;
  Timer? _timer;
  OverlayEntry? _overlayEntry;

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _seconds = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _seconds++);
      _overlayEntry?.markNeedsBuild();
    });
    _showOverlay();
  }

  void _stopRecording() {
    setState(() => _isRecording = false);
    _timer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          width: 150.w,
          height: 150.w,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(16.w)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mic, size: 64.w, color: Colors.white),
              SizedBox(height: 12.w),
              Text('${_seconds}s', style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
              SizedBox(height: 8.w),
              Text('正在录音...', style: TextStyle(fontSize: 14.sp, color: Colors.white.withOpacity(0.8), decoration: TextDecoration.none)),
            ],
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startRecording(),
      onLongPressEnd: (_) => _stopRecording(),
      onLongPressCancel: () => _stopRecording(),
      child: Container(
        height: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: _isRecording ? const Color(0xFFE9EDF2) : const Color(0xFFF1F2F6), borderRadius: BorderRadius.circular(8.w), border: Border.all(color: const Color(0xFFDFE6ED), width: 1.w)),
        child: Text(_isRecording ? '松开 发送' : '按住 说话', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436))),
      ),
    );
  }
}
