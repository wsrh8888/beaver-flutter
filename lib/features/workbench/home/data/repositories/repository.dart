import 'package:beaver/api/workbench.dart';
import 'package:beaver/common/request/request.dart';
import 'package:beaver/types/api/workbench.dart';

class WorkbenchHomeRepository {
  Future<BaseResponse<IListWorkbenchAppsRes>> loadApps() {
    return listWorkbenchAppsApi(const IListWorkbenchAppsReq(clientScope: 2));
  }
}
