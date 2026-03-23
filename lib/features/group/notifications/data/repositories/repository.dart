import 'package:beaver/core/business/group/group.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/types/business/group.dart';

class GroupNotificationRepository {
  final _groupBusiness = getIt<GroupBusiness>();

  Future<List<GroupNotification>> getGroupNotifications() async {
    return await _groupBusiness.getGroupNotifications();
  }

  Future<bool> updateRequestStatus(int id, int status) async {
    return await _groupBusiness.updateGroupRequestStatus(id, status);
  }
}

