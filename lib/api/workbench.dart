import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/workbench.dart';

/// 获取工作台应用列表
Future<BaseResponse<IListWorkbenchAppsRes>> listWorkbenchAppsApi([
  IListWorkbenchAppsReq? data,
]) {
  // return httpClient.get<IListWorkbenchAppsRes>(
  //   '$baseUrl/api/platform/v1/list_workbench',
  //   queryParameters: data?.toJson(),
  //   fromJsonT: (json) => IListWorkbenchAppsRes.fromJson(json),
  // );
  return Future.value(
    BaseResponse(
      code: 0,
      msg: 'ok',
      result: IListWorkbenchAppsRes(
        list: const [
          IWorkbenchAppItem(
            workbenchAppId: 'mock-baidu',
            name: '百度',
            description: '百度搜索（Mock 数据，用于预览工作台效果）',
            icon: 'https://www.baidu.com/favicon.ico',
            entryUrl: 'https://www.baidu.com',
            category: '工具',
            sort: 1,
          ),
        ],
      ),
    ),
  );
}
