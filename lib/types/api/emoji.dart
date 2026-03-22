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

class EmojiCollectItem {
  final String emojiCollectId;
  final String userId;
  final String emojiId;
  final String? packageId;
  final int status;
  final int version;
  final int updatedAt;

  EmojiCollectItem({
    required this.emojiCollectId,
    required this.userId,
    required this.emojiId,
    this.packageId,
    required this.status,
    required this.version,
    required this.updatedAt,
  });

  factory EmojiCollectItem.fromJson(Map<String, dynamic> json) => EmojiCollectItem(
    emojiCollectId: json['emojiCollectId'] ?? '',
    userId: json['userId'] ?? '',
    emojiId: json['emojiId'] ?? '',
    packageId: json['packageId'],
    status: json['status'] ?? 1,
    version: json['version'] ?? 0,
    updatedAt: json['updatedAt'] ?? 0,
  );
}

class EmojiCollectsResponse {
  final List<EmojiCollectItem> collects;
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

// 表情商店相关模型
class EmojiShopPackageItem {
  final String packageId;
  final String title;
  final String coverFile;
  final String description;
  final String type; // 'official' | 'user'
  final int collectCount;
  final int emojiCount;
  final bool isCollected;
  final bool isAuthor;

  EmojiShopPackageItem({
    required this.packageId,
    required this.title,
    required this.coverFile,
    required this.description,
    required this.type,
    required this.collectCount,
    required this.emojiCount,
    required this.isCollected,
    required this.isAuthor,
  });

  factory EmojiShopPackageItem.fromJson(Map<String, dynamic> json) {
    return EmojiShopPackageItem(
      packageId: json['packageId'] ?? '',
      title: json['title'] ?? '',
      coverFile: json['coverFile'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'official',
      collectCount: json['collectCount'] ?? 0,
      emojiCount: json['emojiCount'] ?? 0,
      isCollected: json['isCollected'] ?? false,
      isAuthor: json['isAuthor'] ?? false,
    );
  }
}

class EmojiShopPackagesResponse {
  final int count;
  final List<EmojiShopPackageItem> list;

  EmojiShopPackagesResponse({required this.count, required this.list});
}

class EmojiPackageDetailResponse extends EmojiShopPackageItem {
  final List<EmojiItem> emojis;

  EmojiPackageDetailResponse({
    required super.packageId,
    required super.title,
    required super.coverFile,
    required super.description,
    required super.type,
    required super.collectCount,
    required super.emojiCount,
    required super.isCollected,
    required super.isAuthor,
    required this.emojis,
  });

  factory EmojiPackageDetailResponse.fromJson(Map<String, dynamic> json) {
    return EmojiPackageDetailResponse(
      packageId: json['packageId'] ?? '',
      title: json['title'] ?? '',
      coverFile: json['coverFile'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'official',
      collectCount: json['collectCount'] ?? 0,
      emojiCount: json['emojiCount'] ?? 0,
      isCollected: json['isCollected'] ?? false,
      isAuthor: json['isAuthor'] ?? false,
      emojis: (json['emojis'] as List?)
              ?.map((e) => EmojiItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}
