import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/emoji.dart';

// 获取表情列表（通过ID列表）
Future<BaseResponse<dynamic>> getEmojisByIdsApi(Map<String, dynamic> data) async {
  return httpClient.post(
    '/api/emoji/getEmojisByUuids',
    data: data,
  );
}

// 获取表情收藏列表（通过ID列表）
Future<BaseResponse<EmojiCollectsResponse>> getEmojiCollectsByIdsApi(Map<String, dynamic> data) async {
  return httpClient.post<EmojiCollectsResponse>(
    '/api/emoji/collects-by-ids',
    data: data,
    fromJsonT: (json) => EmojiCollectsResponse(
      collects: (json['collects'] as List).map((e) => EmojiItem.fromJson(e)).toList(),
    ),
  );
}

// 获取表情包收藏列表（通过ID列表）
Future<BaseResponse<EmojiPackageCollectsResponse>> getEmojiPackageCollectsByIdsApi(Map<String, dynamic> data) async {
  return httpClient.post<EmojiPackageCollectsResponse>(
    '/api/emoji/package-collects-by-ids',
    data: data,
    fromJsonT: (json) => EmojiPackageCollectsResponse(
      collects: (json['collects'] as List).map((e) => EmojiPackageItem.fromJson(e)).toList(),
    ),
  );
}

// 获取表情包列表（通过ID列表）
Future<BaseResponse<EmojiPackagesResponse>> getEmojiPackagesByIdsApi(Map<String, dynamic> data) async {
  return httpClient.post<EmojiPackagesResponse>(
    '/api/emoji/packages-by-ids',
    data: data,
    fromJsonT: (json) => EmojiPackagesResponse(
      packages: (json['packages'] as List).map((e) => EmojiPackage.fromJson(e)).toList(),
    ),
  );
}

// 获取表情包内容列表（通过表情包ID列表）
Future<BaseResponse<EmojiPackageContentsResponse>> getEmojiPackageContentsByPackageIdsApi(Map<String, dynamic> data) async {
  return httpClient.post<EmojiPackageContentsResponse>(
    '/api/emoji/package-contents-by-package-ids',
    data: data,
    fromJsonT: (json) => EmojiPackageContentsResponse(
      contents: (json['contents'] as List).map((e) => EmojiPackageContent.fromJson(e)).toList(),
    ),
  );
}

// 获取表情包内容列表（通过关联ID列表）
Future<BaseResponse<EmojiPackageContentsResponse>> getEmojiPackageContentsByRelationIdsApi(Map<String, dynamic> data) async {
  return httpClient.post<EmojiPackageContentsResponse>(
    '/api/emoji/package-contents-by-relation-ids',
    data: data,
    fromJsonT: (json) => EmojiPackageContentsResponse(
      contents: (json['contents'] as List).map((e) => EmojiPackageContent.fromJson(e)).toList(),
    ),
  );
}
