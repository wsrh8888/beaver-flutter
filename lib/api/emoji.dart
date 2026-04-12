import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/emoji.dart';
import 'package:beaver/common/config/env.dart';

// 获取表情列表（通过ID列表）
Future<BaseResponse<dynamic>> getEmojisByIdsApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post('$baseUrl/api/emoji/getEmojisByUuids', data: data);
}

// 获取表情收藏列表（通过ID列表）
Future<BaseResponse<EmojiCollectsResponse>> getEmojiCollectsByIdsApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post<EmojiCollectsResponse>(
    '$baseUrl/api/emoji/collects-by-ids',
    data: data,
    fromJsonT: (json) => EmojiCollectsResponse(
      collects: (json['collects'] as List)
          .map((e) => EmojiCollectItem.fromJson(e))
          .toList(),
    ),
  );
}

// 获取表情包收藏列表（通过ID列表）
Future<BaseResponse<EmojiPackageCollectsResponse>>
getEmojiPackageCollectsByIdsApi(Map<String, dynamic> data) async {
  return httpClient.post<EmojiPackageCollectsResponse>(
    '$baseUrl/api/emoji/package-collects-by-ids',
    data: data,
    fromJsonT: (json) => EmojiPackageCollectsResponse(
      collects: (json['collects'] as List)
          .map((e) => EmojiPackageItem.fromJson(e))
          .toList(),
    ),
  );
}

// 获取表情包列表（通过ID列表）
Future<BaseResponse<EmojiPackagesResponse>> getEmojiPackagesByIdsApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post<EmojiPackagesResponse>(
    '$baseUrl/api/emoji/packages-by-ids',
    data: data,
    fromJsonT: (json) => EmojiPackagesResponse(
      packages: (json['packages'] as List)
          .map((e) => EmojiPackage.fromJson(e))
          .toList(),
    ),
  );
}

// 获取表情包内容列表（通过表情包ID列表）
Future<BaseResponse<EmojiPackageContentsResponse>>
getEmojiPackageContentsByPackageIdsApi(Map<String, dynamic> data) async {
  return httpClient.post<EmojiPackageContentsResponse>(
    '$baseUrl/api/emoji/package-contents-by-package-ids',
    data: data,
    fromJsonT: (json) => EmojiPackageContentsResponse(
      contents: (json['contents'] as List)
          .map((e) => EmojiPackageContent.fromJson(e))
          .toList(),
    ),
  );
}

// 获取表情包内容列表（通过关联ID列表）
Future<BaseResponse<EmojiPackageContentsResponse>>
getEmojiPackageContentsByRelationIdsApi(Map<String, dynamic> data) async {
  return httpClient.post<EmojiPackageContentsResponse>(
    '$baseUrl/api/emoji/package-contents-by-relation-ids',
    data: data,
    fromJsonT: (json) => EmojiPackageContentsResponse(
      contents: (json['contents'] as List)
          .map((e) => EmojiPackageContent.fromJson(e))
          .toList(),
    ),
  );
}
// 获取表情包列表（商店列表）
Future<BaseResponse<EmojiShopPackagesResponse>> getEmojiPackagesApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post<EmojiShopPackagesResponse>(
    '$baseUrl/api/emoji/packageList',
    data: data,
    fromJsonT: (json) => EmojiShopPackagesResponse(
      count: json['count'] ?? 0,
      list: (json['list'] as List)
          .map((e) => EmojiShopPackageItem.fromJson(e))
          .toList(),
    ),
  );
}

// 获取表情包详情
Future<BaseResponse<EmojiPackageDetailResponse>> getEmojiPackageDetailApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post<EmojiPackageDetailResponse>(
    '$baseUrl/api/emoji/packageInfo',
    data: data,
    fromJsonT: (json) => EmojiPackageDetailResponse.fromJson(json),
  );
}

// 更新表情包收藏状态（订阅/取消订阅）
Future<BaseResponse<dynamic>> updateFavoriteEmojiPackageApi(
  Map<String, dynamic> data,
) async {
  return httpClient.post('$baseUrl/api/emoji/packageFavorite', data: data);
}
