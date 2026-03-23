import 'package:equatable/equatable.dart';

/// 表情基础模型 (对应 PC 端 IEmojiBase)
class EmojiModel extends Equatable {
  final String emojiId;
  final String name;
  final String fileKey;
  final int? version;
  final String? packageId;

  const EmojiModel({
    required this.emojiId,
    required this.name,
    required this.fileKey,
    this.version,
    this.packageId,
  });

  factory EmojiModel.fromJson(Map<String, dynamic> json) {
    return EmojiModel(
      emojiId: json['emojiId'] ?? '',
      name: json['name'] ?? '',
      fileKey: json['fileKey'] ?? json['icon'] ?? '',
      version: json['version'],
      packageId: json['packageId'],
    );
  }

  @override
  List<Object?> get props => [emojiId, name, fileKey, version, packageId];
}

/// 表情包模型 (对应 PC 端 IEmojiPackageBase)
class EmojiPackageModel extends Equatable {
  final String packageId;
  final String title;
  final String coverFile;

  const EmojiPackageModel({
    required this.packageId,
    required this.title,
    required this.coverFile,
  });

  factory EmojiPackageModel.fromJson(Map<String, dynamic> json) {
    return EmojiPackageModel(
      packageId: json['packageId'] ?? '',
      title: json['title'] ?? '',
      coverFile: json['coverFile'] ?? '',
    );
  }

  @override
  List<Object?> get props => [packageId, title, coverFile];
}

/// 收藏表情模型 (对应 PC 端 IFavoriteEmoji)
class FavoriteEmojiModel extends Equatable {
  final String emojiId;
  final String fileKey;
  final String title;
  final String? packageId;
  final int? width;
  final int? height;

  const FavoriteEmojiModel({
    required this.emojiId,
    required this.fileKey,
    required this.title,
    this.packageId,
    this.width,
    this.height,
  });

  factory FavoriteEmojiModel.fromJson(Map<String, dynamic> json) {
    return FavoriteEmojiModel(
      emojiId: json['emojiId'] ?? '',
      fileKey: json['fileKey'] ?? '',
      title: json['title'] ?? '',
      packageId: json['packageId'],
      width: json['width'],
      height: json['height'],
    );
  }

  @override
  List<Object?> get props => [emojiId, fileKey, title, packageId, width, height];
}
