import 'package:beaver/common/config/env.dart';
import 'package:beaver/common/http/http_client.dart';

// 类型定义
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

// 获取表情列表（通过ID列表）
Future<dynamic> getEmojisByIdsApi(Map<String, dynamic> data) async {
  return HttpClient.post(
    '${Env.baseUrl}/api/emoji/getEmojisByUuids',
    data: data,
  );
}

// 获取表情收藏列表（通过ID列表）
Future<EmojiCollectsResponse> getEmojiCollectsByIdsApi(Map<String, dynamic> data) async {
  final response = await HttpClient.post(
    '${Env.baseUrl}/api/emoji/collects-by-ids',
    data: data,
  );
  return EmojiCollectsResponse(
    collects: (response['collects'] as List).map((e) => EmojiItem(
          emojiId: e['emojiId'],
          userId: e['userId'],
          emojiCode: e['emojiCode'],
          version: e['version'],
          createdAt: e['createdAt'],
          updatedAt: e['updatedAt'],
        )).toList(),
  );
}

// 获取表情包收藏列表（通过ID列表）
Future<EmojiPackageCollectsResponse> getEmojiPackageCollectsByIdsApi(Map<String, dynamic> data) async {
  final response = await HttpClient.post(
    '${Env.baseUrl}/api/emoji/package-collects-by-ids',
    data: data,
  );
  return EmojiPackageCollectsResponse(
    collects: (response['collects'] as List).map((e) => EmojiPackageItem(
          packageId: e['packageId'],
          userId: e['userId'],
          packageCode: e['packageCode'],
          version: e['version'],
          createdAt: e['createdAt'],
          updatedAt: e['updatedAt'],
        )).toList(),
  );
}

// 获取表情包列表（通过ID列表）
Future<EmojiPackagesResponse> getEmojiPackagesByIdsApi(Map<String, dynamic> data) async {
  final response = await HttpClient.post(
    '${Env.baseUrl}/api/emoji/packages-by-ids',
    data: data,
  );
  return EmojiPackagesResponse(
    packages: (response['packages'] as List).map((e) => EmojiPackage(
          id: e['id'],
          packageId: e['packageId'],
          title: e['title'],
          coverFile: e['coverFile'],
          userId: e['userId'],
          description: e['description'],
          type: e['type'],
          status: e['status'],
          version: e['version'],
          createdAt: e['createdAt'],
          updatedAt: e['updatedAt'],
        )).toList(),
  );
}

// 获取表情包内容列表（通过表情包ID列表）
Future<EmojiPackageContentsResponse> getEmojiPackageContentsByPackageIdsApi(Map<String, dynamic> data) async {
  final response = await HttpClient.post(
    '${Env.baseUrl}/api/emoji/package-contents-by-package-ids',
    data: data,
  );
  return EmojiPackageContentsResponse(
    contents: (response['contents'] as List).map((e) => EmojiPackageContent(
          relationId: e['relationId'],
          packageId: e['packageId'],
          emojiId: e['emojiId'],
          sortOrder: e['sortOrder'],
          version: e['version'],
          createdAt: e['createdAt'],
          updatedAt: e['updatedAt'],
        )).toList(),
  );
}

// 获取表情包内容列表（通过关联ID列表）
Future<EmojiPackageContentsResponse> getEmojiPackageContentsByRelationIdsApi(Map<String, dynamic> data) async {
  final response = await HttpClient.post(
    '${Env.baseUrl}/api/emoji/package-contents-by-relation-ids',
    data: data,
  );
  return EmojiPackageContentsResponse(
    contents: (response['contents'] as List).map((e) => EmojiPackageContent(
          relationId: e['relationId'],
          packageId: e['packageId'],
          emojiId: e['emojiId'],
          sortOrder: e['sortOrder'],
          version: e['version'],
          createdAt: e['createdAt'],
          updatedAt: e['updatedAt'],
        )).toList(),
  );
}
