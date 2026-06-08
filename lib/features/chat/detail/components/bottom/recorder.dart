import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:beaver/core/business/media/media.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/features/chat/detail/bloc/bloc.dart';
import 'package:beaver/features/chat/detail/bloc/event.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/business/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// 按住说话录音区（对标微信：按下即录、上滑取消、最长 60 秒）
class ChatRecorder extends StatefulWidget {
  final String conversationId;

  const ChatRecorder({super.key, required this.conversationId});

  @override
  State<ChatRecorder> createState() => _ChatRecorderState();
}

class _ChatRecorderState extends State<ChatRecorder>
    with TickerProviderStateMixin {
  static const double _maxDurationSeconds = 60;
  static const double _minDurationSeconds = 1;
  static const double _cancelSlideThreshold = 80;

  bool _isRecording = false;
  bool _inCancelZone = false;
  bool _pressActive = false;
  bool _isStarting = false;
  double _recordingDuration = 0;
  Offset? _pressStartLocal;

  final AudioRecorder _audioRecorder = AudioRecorder();
  Timer? _timer;
  OverlayEntry? _overlayEntry;

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
    _removeOverlay();
    unawaited(_safeStopAndDelete());
    _audioRecorder.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _safeStopAndDelete() async {
    try {
      if (await _audioRecorder.isRecording()) {
        final path = await _audioRecorder.stop();
        if (path != null && File(path).existsSync()) {
          File(path).deleteSync();
        }
      }
    } catch (_) {}
  }

  Future<void> _startRecording() async {
    if (_isStarting || _isRecording || !_pressActive) return;

    if (!await Permission.microphone.isGranted) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        _pressActive = false;
        if (mounted) BeaverToast.show(context, '请开启麦克风权限');
        return;
      }
    }

    if (!_pressActive) return;

    _isStarting = true;
    final tempDir = await getTemporaryDirectory();
    if (!_pressActive) {
      _isStarting = false;
      return;
    }

    final path = p.join(
      tempDir.path,
      'voice_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    try {
      await _audioRecorder.start(const RecordConfig(), path: path);

      if (!_pressActive || !mounted) {
        await _safeStopAndDelete();
        _isStarting = false;
        return;
      }

      setState(() {
        _isRecording = true;
        _inCancelZone = false;
        _recordingDuration = 0;
      });
      _waveController.repeat(reverse: true);
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (!_isRecording) return;
        _recordingDuration += 0.1;
        _overlayEntry?.markNeedsBuild();
        if (_recordingDuration >= _maxDurationSeconds) {
          unawaited(_stopRecording(cancel: false));
        }
      });
      _showOverlay();
    } catch (_) {
      if (mounted) BeaverToast.show(context, '录音启动失败');
    } finally {
      _isStarting = false;
    }
  }

  void _updateCancelZone(Offset localPosition) {
    if (!_isRecording || _pressStartLocal == null) return;

    final dy = localPosition.dy - _pressStartLocal!.dy;
    final shouldCancel = dy < -_cancelSlideThreshold;
    if (shouldCancel != _inCancelZone) {
      setState(() => _inCancelZone = shouldCancel);
      _overlayEntry?.markNeedsBuild();
    }
  }

  Future<void> _stopRecording({required bool cancel}) async {
    _pressActive = false;
    _pressStartLocal = null;

    if (!_isRecording) {
      await _safeStopAndDelete();
      return;
    }

    final path = await _audioRecorder.stop();
    _timer?.cancel();
    _waveController.stop();
    _removeOverlay();

    setState(() {
      _isRecording = false;
      _inCancelZone = false;
    });

    if (cancel || path == null) {
      if (path != null && File(path).existsSync()) {
        File(path).deleteSync();
      }
      return;
    }

    final duration = _recordingDuration.round();
    if (duration < _minDurationSeconds) {
      if (mounted) BeaverToast.show(context, '说话时间太短');
      if (File(path).existsSync()) File(path).deleteSync();
      return;
    }

    await _sendVoiceMessage(path, duration);
  }

  Future<void> _sendVoiceMessage(String path, int duration) async {
    final mediaBusiness = getIt<MediaBusiness>();
    final chatBloc = context.read<ChatBloc>();

    final uploadResult = await mediaBusiness.uploadFile(path);
    if (uploadResult == null) {
      if (mounted) BeaverToast.show(context, '语音发送失败');
      if (File(path).existsSync()) File(path).deleteSync();
      return;
    }

    chatBloc.add(
      SendMessageEvent(
        MessageContentModel(
          type: MessageType.voice,
          voiceMsg: VoiceMsg(
            fileUrl: uploadResult.fileUrl,
            duration: duration,
          ),
        ),
        conversationId: widget.conversationId,
      ),
    );

    if (File(path).existsSync()) File(path).deleteSync();
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Container(color: Colors.black.withValues(alpha: 0.08)),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.w),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 156.w,
                  padding: EdgeInsets.symmetric(vertical: 28.w, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: _inCancelZone
                        ? const Color(0xCCFF5252)
                        : const Color(0xCC333333),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_inCancelZone)
                        Icon(Icons.close_rounded, size: 56.w, color: Colors.white)
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.mic_rounded, size: 48.w, color: Colors.white),
                            SizedBox(width: 8.w),
                            _buildWaveform(),
                          ],
                        ),
                      SizedBox(height: 14.w),
                      Text(
                        _inCancelZone ? '松开手指，取消发送' : '手指上滑，取消发送',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white.withValues(alpha: 0.95),
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!_inCancelZone) ...[
                        SizedBox(height: 10.w),
                        Text(
                          '${_recordingDuration.ceil().clamp(0, _maxDurationSeconds.toInt())}″',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
          height: (10 + (index * 6 * _waveController.value)).w,
          margin: EdgeInsets.symmetric(horizontal: 1.5.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.w),
          ),
        );
      }),
    );
  }

  String get _buttonLabel {
    if (!_isRecording) return '按住 说话';
    if (_inCancelZone) return '松开 取消';
    return '松开 发送';
  }

  Color get _buttonColor {
    if (!_isRecording) return const Color(0xFFF7F7F7);
    if (_inCancelZone) return const Color(0xFFFFEBEE);
    return const Color(0xFFD8D8D8);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        _pressActive = true;
        _pressStartLocal = event.localPosition;
        unawaited(_startRecording());
      },
      onPointerMove: (event) => _updateCancelZone(event.localPosition),
      onPointerUp: (_) => unawaited(_stopRecording(cancel: _inCancelZone)),
      onPointerCancel: (_) => unawaited(_stopRecording(cancel: true)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 42.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _buttonColor,
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(
            color: _isRecording ? Colors.transparent : const Color(0xFFE8E8E8),
            width: 1.w,
          ),
        ),
        child: Text(
          _buttonLabel,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: _inCancelZone
                ? const Color(0xFFE53935)
                : const Color(0xFF181818),
          ),
        ),
      ),
    );
  }
}
