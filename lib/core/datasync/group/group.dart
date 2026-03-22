import 'package:beaver/core/datasync/index.dart';

/// 群组数据同步统一入口
class GroupDatasync {
  Future<void> checkAndSync() async {
    // 按顺序执行群组相关数据同步
    await groupSync.checkAndSync(); // 1. 同步群资料
    await groupMemberSync.checkAndSync(); // 2. 同步群成员
    await groupJoinRequestSync.checkAndSync(); // 3. 同步入群申请
  }
}

final groupDatasync = GroupDatasync();
