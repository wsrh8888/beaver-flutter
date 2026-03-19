class EmojiItem {
  final String emojiId;
  final String userId;
  final String emojiCode;
  final int version;
  final String createdAt;
  final String updatedAt;

  EmojiItem({
    required this.emojiId,
    required this.userId,
    required this.emojiCode,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmojiItem.fromJson(Map<String, dynamic> json) => EmojiItem(
    emojiId: json['emojiId'] ?? '',
    userId: json['userId'] ?? '',
    emojiCode: json['emojiCode'] ?? '',
    version: json['version'] ?? 0,
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
  );
}

class EmojiPackageItem {
  final String packageId;
  final String userId;
  final String packageCode;
  final int version;
  final String createdAt;
  final String updatedAt;

  EmojiPackageItem({
    required this.packageId,
    required this.userId,
    required this.packageCode,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmojiPackageItem.fromJson(Map<String, dynamic> json) => EmojiPackageItem(
    packageId: json['packageId'] ?? '',
    userId: json['userId'] ?? '',
    packageCode: json['packageCode'] ?? '',
    version: json['version'] ?? 0,
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
  );
}

class EmojiPackage {
  final int id;
  final String packageId;
  final String title;
  final String coverFile;
  final String userId;
  final String description;
  final String type;
  final int status;
  final int version;
  final String createdAt;
  final String updatedAt;

  EmojiPackage({
    required this.id,
    required this.packageId,
    required this.title,
    required this.coverFile,
    required this.userId,
    required this.description,
    required this.type,
    required this.status,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmojiPackage.fromJson(Map<String, dynamic> json) => EmojiPackage(
    id: json['id'] ?? 0,
    packageId: json['packageId'] ?? '',
    title: json['title'] ?? '',
    coverFile: json['coverFile'] ?? '',
    userId: json['userId'] ?? '',
    description: json['description'] ?? '',
    type: json['type'] ?? '',
    status: json['status'] ?? 0,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
  );
}

class EmojiPackageContent {
  final String relationId;
  final String packageId;
  final String emojiId;
  final int sortOrder;
  final int version;
  final String createdAt;
  final String updatedAt;

  EmojiPackageContent({
    required this.relationId,
    required this.packageId,
    required this.emojiId,
    required this.sortOrder,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmojiPackageContent.fromJson(Map<String, dynamic> json) => EmojiPackageContent(
    relationId: json['relationId'] ?? '',
    packageId: json['packageId'] ?? '',
    emojiId: json['emojiId'] ?? '',
    sortOrder: json['sortOrder'] ?? 0,
    version: json['version'] ?? 0,
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
  );
}

class EmojiCollectsResponse {
  final List<EmojiItem> collects;
  EmojiCollectsResponse({required this.collects});
}

class EmojiPackageCollectsResponse {
  final List<EmojiPackageItem> collects;
  EmojiPackageCollectsResponse({required this.collects});
}

class EmojiPackagesResponse {
  final List<EmojiPackage> packages;
  EmojiPackagesResponse({required this.packages});
}

class EmojiPackageContentsResponse {
  final List<EmojiPackageContent> contents;
  EmojiPackageContentsResponse({required this.contents});
}
