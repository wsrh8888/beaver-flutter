import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:beaver/common/logger/index.dart';
import 'package:beaver/core/cache/media_manager.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/store/message_media/message_media.dart';
import 'package:beaver/types/cache.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoicePlayerState extends Equatable {
  final String? playingMessageId;

  const VoicePlayerState({this.playingMessageId});

  VoicePlayerState copyWith({String? playingMessageId, bool clearPlaying = false}) {
    return VoicePlayerState(
      playingMessageId: clearPlaying ? null : (playingMessageId ?? this.playingMessageId),
    );
  }

  bool isPlaying(String messageId) => playingMessageId == messageId;

  @override
  List<Object?> get props => [playingMessageId];
}

class VoicePlayerStore extends Cubit<VoicePlayerState> {
  final AudioPlayer _player = AudioPlayer();
  final Logger _logger = Logger('voice-player');

  VoicePlayerStore() : super(const VoicePlayerState()) {
    _player.setReleaseMode(ReleaseMode.stop);
    _player.onPlayerComplete.listen((_) {
      _logger.info({'text': '播放完成'});
      stop();
    });
  }

  Future<void> toggleVoice(String messageId, String fileUrl) async {
    _logger.info({
      'text': '点击语音',
      'messageId': messageId,
      'fileUrl': fileUrl,
    });

    if (messageId.isEmpty || fileUrl.isEmpty) {
      _logger.warn({'text': '参数为空，跳过播放'});
      return;
    }

    if (state.isPlaying(messageId)) {
      _logger.info({'text': '正在播放，执行停止'});
      await stop();
      return;
    }

    await stop();

    try {
      final source = await _buildPlaySource(fileUrl);
      if (source == null) {
        _logger.warn({
          'text': '无法构造播放源',
          'messageId': messageId,
          'fileUrl': fileUrl,
        });
        return;
      }

      _logger.info({
        'text': '开始播放',
        'messageId': messageId,
        'source': source.runtimeType.toString(),
      });

      emit(state.copyWith(playingMessageId: messageId));
      await _player.play(source);
      getIt<MessageMediaStore>().mark(messageId);

      _logger.info({'text': '播放已启动', 'messageId': messageId});
    } catch (error, stack) {
      _logger.error({
        'text': '播放失败',
        'messageId': messageId,
        'fileUrl': fileUrl,
        'error': error.toString(),
        'stack': stack.toString(),
      });
      await stop();
    }
  }

  Future<void> toggle(String fileUrl) {
    final playbackId = fileUrl.isEmpty ? '' : 'voice-url:$fileUrl';
    return toggleVoice(playbackId, fileUrl);
  }

  Future<void> stop() async {
    await _player.stop();
    emit(state.copyWith(clearPlaying: true));
  }

  Future<Source?> _buildPlaySource(String fileUrl) async {
    if (fileUrl.startsWith('file://')) {
      final path = _stripFileScheme(fileUrl);
      final exists = File(path).existsSync();
      _logger.info({'text': '本地 file://', 'path': path, 'exists': exists});
      return exists ? DeviceFileSource(path) : null;
    }

    final mediaPath = await MediaManager().get(CacheType.voice, fileUrl);
    _logger.info({'text': 'MediaManager.get', 'mediaPath': mediaPath});

    if (mediaPath.startsWith('file://')) {
      final path = _stripFileScheme(mediaPath);
      _logger.info({'text': '命中缓存 file://', 'path': path});
      return DeviceFileSource(path);
    }

    if (mediaPath.startsWith('http://') || mediaPath.startsWith('https://')) {
      _logger.info({'text': '未命中本地缓存，开始下载', 'url': mediaPath});
      final localPath = await MediaManager().add(CacheType.voice, fileUrl);
      _logger.info({'text': '下载完成', 'localPath': localPath});

      if (localPath != null && File(localPath).existsSync()) {
        return DeviceFileSource(localPath);
      }

      _logger.info({'text': '回退 UrlSource 在线播放', 'url': mediaPath});
      return UrlSource(mediaPath);
    }

    if (File(mediaPath).existsSync()) {
      _logger.info({'text': '命中本地绝对路径', 'path': mediaPath});
      return DeviceFileSource(mediaPath);
    }

    return null;
  }

  String _stripFileScheme(String path) {
    if (path.startsWith('file://')) {
      return path.substring(7);
    }
    return path;
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
