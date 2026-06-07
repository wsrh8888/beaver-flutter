class IFileUploadResult {
  final String fileUrl;
  final String originalName;
  final FileInfo? fileInfo;

  IFileUploadResult({
    required this.fileUrl,
    required this.originalName,
    this.fileInfo,
  });

  factory IFileUploadResult.fromJson(Map<String, dynamic> json) {
    return IFileUploadResult(
      fileUrl: json['fileUrl']?.toString() ?? '',
      originalName: json['originalName'] ?? '',
      fileInfo: json['fileInfo'] != null ? FileInfo.fromJson(json['fileInfo']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileUrl': fileUrl,
      'originalName': originalName,
      'fileInfo': fileInfo?.toJson(),
    };
  }
}

class FileInfo {
  final String type;
  final ImageSize? imageFile;
  final AudioInfo? audioFile;
  final VideoInfo? videoFile;

  FileInfo({
    required this.type,
    this.imageFile,
    this.audioFile,
    this.videoFile,
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      type: json['type'] ?? 'other',
      imageFile: json['imageFile'] != null ? ImageSize.fromJson(json['imageFile']) : null,
      audioFile: json['audioFile'] != null ? AudioInfo.fromJson(json['audioFile']) : null,
      videoFile: json['videoFile'] != null ? VideoInfo.fromJson(json['videoFile']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'imageFile': imageFile?.toJson(),
      'audioFile': audioFile?.toJson(),
      'videoFile': videoFile?.toJson(),
    };
  }
}

class ImageSize {
  final int width;
  final int height;

  ImageSize({required this.width, required this.height});

  factory ImageSize.fromJson(Map<String, dynamic> json) {
    return ImageSize(
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'width': width, 'height': height};
}

class AudioInfo {
  final int duration;

  AudioInfo({required this.duration});

  factory AudioInfo.fromJson(Map<String, dynamic> json) {
    return AudioInfo(
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'duration': duration};
}

class VideoInfo {
  final int width;
  final int height;
  final int duration;

  VideoInfo({
    required this.width,
    required this.height,
    required this.duration,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'width': width,
    'height': height,
    'duration': duration,
  };
}
