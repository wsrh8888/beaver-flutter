import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/group/list/bloc/bloc.dart';
import 'package:beaver/features/group/list/bloc/event.dart';
import 'package:beaver/features/group/list/bloc/state.dart';
import 'package:beaver/features/group/list/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:go_router/go_router.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  late GroupListBloc _groupListBloc;

  @override
  void initState() {
    super.initState();
    _groupListBloc = GroupListBloc(GroupListRepository())..add(LoadGroupListEvent());
  }

  @override
  void dispose() {
    _groupListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _groupListBloc,
      child: BlocBuilder<GroupListBloc, GroupListState>(
        builder: (context, state) {
          return BeaverLayout(
            title: '群聊',
            showBack: true,
            child: ListView.separated(
              itemCount: state.groupList.length,
              separatorBuilder: (context, index) => Divider(height: 1.w, color: Colors.grey.withOpacity(0.1)),
              itemBuilder: (context, index) {
                final group = state.groupList[index];
                return ListTile(
                  leading: BeaverAvatar(url: group.fileName, size: 48.w, nickname: group.title),
                  title: Text(group.title, style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.bold)),
                  subtitle: Text(group.lastMessage ?? '暂无消息', maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Text('${group.memberCount}人', style: TextStyle(fontSize: 12.w, color: Colors.grey)),
                  onTap: () => context.push('/chat/detail?id=${group.id}&type=group'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
