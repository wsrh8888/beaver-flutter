import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/core/business/group/group_join_request.dart';
import 'package:beaver/types/business/group.dart';

class GroupJoinRequestStoreState extends Equatable {
  final List<GroupNotification> groupJoinRequests;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final int unreadCount;

  const GroupJoinRequestStoreState({
    this.groupJoinRequests = const [],
    this.totalCount = 0,
    this.currentPage = 1,
    this.pageSize = 20,
    this.unreadCount = 0,
  });

  GroupJoinRequestStoreState copyWith({
    List<GroupNotification>? groupJoinRequests,
    int? totalCount,
    int? currentPage,
    int? pageSize,
    int? unreadCount,
  }) {
    return GroupJoinRequestStoreState(
      groupJoinRequests: groupJoinRequests ?? this.groupJoinRequests,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [
    groupJoinRequests,
    totalCount,
    currentPage,
    pageSize,
    unreadCount,
  ];
}

class GroupJoinRequestStore extends Cubit<GroupJoinRequestStoreState> {
  final GroupJoinRequestBusiness _groupJoinRequestBusiness;

  GroupJoinRequestStore({GroupJoinRequestBusiness? groupJoinRequestBusiness})
    : _groupJoinRequestBusiness = groupJoinRequestBusiness ?? getIt<GroupJoinRequestBusiness>(),
      super(const GroupJoinRequestStoreState());

  Future<void> init({int page = 1, int limit = 20}) async {
    try {
      final requests = await _groupJoinRequestBusiness.getGroupNotifications();
      final unreadCount = await _groupJoinRequestBusiness.getUnreadGroupNotificationCount();
      emit(state.copyWith(
        groupJoinRequests: requests,
        totalCount: requests.length,
        currentPage: page,
        pageSize: limit,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      print('GroupJoinRequestStore: 初始化失败: $e');
    }
  }

  Future<void> handleRequest(int requestId, int status) async {
    try {
      await _groupJoinRequestBusiness.updateGroupRequestStatus(requestId, status);
      await refresh();
    } catch (e) {
      print('GroupJoinRequestStore: 处理群申请失败: $e');
    }
  }

  Future<void> refresh() async {
    await init(
      page: state.currentPage,
      limit: state.pageSize,
    );
  }

  Future<void> loadMore() async {
    if (state.groupJoinRequests.length >= state.totalCount) {
      return;
    }
    final nextPage = state.currentPage + 1;
    try {
      final requests = await _groupJoinRequestBusiness.getGroupNotifications();
      final newList = [...state.groupJoinRequests, ...requests];
      emit(state.copyWith(
        groupJoinRequests: newList,
        totalCount: requests.length,
        currentPage: nextPage,
      ));
    } catch (e) {
      print('GroupJoinRequestStore: 加载更多失败: $e');
    }
  }
}
