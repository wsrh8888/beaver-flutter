import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:beaver/core/business/media/media.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class ChatRecorder extends StatefulWidget {
  const ChatRecorder({super.key});

  @override
  State<ChatRecorder> createState() => _ChatRecorderState();
}

class _ChatRecorderState extends State<ChatRecorder> with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _expectCancel = false;
  double _recordingDuration = 0.0;
  // 录音引擎
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _tempPath;
  Timer? _timer;
  OverlayEntry? _overlayEntry;

  // 动画控制
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        if (_isRecording) {
          _overlayEntry?.markNeedsBuild();
        }
      });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    // 1. 权限检查
    if (!await Permission.microphone.request().isGranted) {
      if (mounted) BeaverToast.show(context, '请开启麦克风权限');
      return;
    }

    if (await _audioRecorder.isRecording()) return;

    // 2. 准备路径
    final tempDir = await getTemporaryDirectory();
    final path = p.join(tempDir.path, 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a');

    // 3. 开始录制
    try {
      const config = RecordConfig();
      await _audioRecorder.start(config, path: path);

      setState(() {
        _isRecording = true;
        _expectCancel = false;
        _recordingDuration = 0.0;
      });
      _waveController.repeat(reverse: true);
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        _recordingDuration += 0.1;
        _overlayEntry?.markNeedsBuild();
      });
      _showOverlay();
    } catch (e) {
      if (mounted) BeaverToast.show(context, '录音机启动失败');
    }
  }

  Future<void> _stopRecording({bool cancel = false}) async {
    if (!_isRecording) return;
    
    final path = await _audioRecorder.stop();
    
    setState(() {
      _isRecording = false;
      _expectCancel = false;
    });
    _waveController.stop();
    _timer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (cancel || path == null) {
      if (path != null) File(path).delete();
    } else {
      final duration = _recordingDuration.toInt();
      if (duration < 1) {
        if (mounted) BeaverToast.show(context, '说话时间太短');
        File(path).delete();
        return;
      }
      _sendVoiceMessage(path, duration);
    }
  }

  void _updateSwipeStatus(LongPressMoveUpdateDetails details) {
    final bool cancel = details.localOffsetFromOrigin.dy < -60;
    if (cancel != _expectCancel) {
      setState(() => _expectCancel = cancel);
      _overlayEntry?.markNeedsBuild();
    }
  }

  Future<void> _sendVoiceMessage(String path, int duration) async {
    final mediaBusiness = getIt<MediaBusiness>();
    final chatBloc = context.read<ChatBloc>();

    // 1. 上传文件 (调用 API 层)
    final uploadResult = await mediaBusiness.uploadFile(path);
    if (uploadResult == null) {
      if (mounted) BeaverToast.show(context, '语音发送失败');
      return;
    }

    // 2. 构造消息并派发 Event
    chatBloc.add(
      SendMessageEvent(
        MessageContentModel(
          type: MessageType.voice,
          voiceMsg: VoiceMsg(
            fileKey: uploadResult.fileKey,
            duration: duration,
          ),
        ),
      ),
    );

    // 3. 清理缓存
    File(path).delete();
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.transparent)),
          Center(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: 160.w,
                  height: 160.w,
                  decoration: BoxDecoration(
                    color: _expectCancel ? Colors.red.withOpacity(0.8) : Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_expectCancel)
                        Icon(Icons.undo_rounded, size: 68.w, color: Colors.white)
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.mic_rounded, size: 60.w, color: Colors.white),
                            SizedBox(width: 8.w),
                            _buildWaveform(),
                          ],
                        ),
                      SizedBox(height: 16.w),
                      Text(
                        _expectCancel ? '松开手指 取消发送' : '手指上滑 取消发送',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white.withOpacity(0.9),
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!_expectCancel)
                        Padding(
                          padding: EdgeInsets.only(top: 8.w),
                          child: Text(
                            '${_recordingDuration.toInt()}s',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildWaveform() {
    return Row(
      children: List.generate(5, (index) {
        return Container(
          width: 3.w,
          height: (12 + (index * 8 * _waveController.value)).w,
          margin: EdgeInsets.symmetric(horizontal: 1.5.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.w),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startRecording(),
      onLongPressMoveUpdate: (details) => _updateSwipeStatus(details),
      onLongPressEnd: (_) => _stopRecording(cancel: _expectCancel),
      onLongPressCancel: () => _stopRecording(cancel: true),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 42.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isRecording ? const Color(0xFFD1D1D1) : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(
            color: _isRecording ? Colors.transparent : const Color(0xFFE8E8E8),
            width: 1.w,
          ),
        ),
        child: Text(
          _isRecording ? '松开 发送' : '按住 说话',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181818),
          ),
        ),
      ),
    );
  }
}
