import 'package:audioplayers/audioplayers.dart';
import 'package:beaver/core/cache/media_manager.dart';
import 'package:beaver/types/cache.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoicePlayerState extends Equatable {
  final String? playingFileUrl;
  final List<String> playedFileUrls;

  const VoicePlayerState({
    this.playingFileUrl,
    this.playedFileUrls = const [],
  });

  VoicePlayerState copyWith({
    String? playingFileUrl,
    List<String>? playedFileUrls,
    bool clearPlaying = false,
  }) {
    return VoicePlayerState(
      playingFileUrl: clearPlaying ? null : (playingFileUrl ?? this.playingFileUrl),
      playedFileUrls: playedFileUrls ?? this.playedFileUrls,
    );
  }

  bool isPlaying(String fileUrl) => playingFileUrl == fileUrl;

  bool hasPlayed(String fileUrl) => playedFileUrls.contains(fileUrl);

  @override
  List<Object?> get props => [playingFileUrl, playedFileUrls];
}

class VoicePlayerStore extends Cubit<VoicePlayerState> {
  final AudioPlayer _player = AudioPlayer();

  VoicePlayerStore() : super(const VoicePlayerState()) {
    _player.onPlayerComplete.listen((_) => stop());
  }

  Future<void> toggle(String fileUrl) async {
    if (fileUrl.isEmpty) {
      return;
    }

    if (state.isPlaying(fileUrl)) {
      await stop();
      return;
    }

    await stop();

    final localPath = await MediaManager().get(CacheType.voice, fileUrl);
    final playPath = _resolvePlayPath(localPath);
    final source = playPath.startsWith('http')
        ? UrlSource(playPath)
        : DeviceFileSource(playPath);

    emit(state.copyWith(playingFileUrl: fileUrl, playedFileUrls: _markPlayed(fileUrl)));
    await _player.play(source);
  }

  Future<void> stop() async {
    await _player.stop();
    emit(state.copyWith(clearPlaying: true));
  }

  List<String> _markPlayed(String fileUrl) {
    if (state.playedFileUrls.contains(fileUrl)) {
      return state.playedFileUrls;
    }
    return [...state.playedFileUrls, fileUrl];
  }

  String _resolvePlayPath(String path) {
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
