import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/group/create/bloc/bloc.dart';
import 'package:beaver/features/group/create/bloc/event.dart';
import 'package:beaver/features/group/create/bloc/state.dart';

import 'package:beaver/types/business/group.dart';
import 'package:beaver/shared/ui/avatar/index.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late CreateGroupBloc _createGroupBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _createGroupBloc = CreateGroupBloc()..add(LoadContactsEvent());
    _searchController.addListener(() {
      _createGroupBloc.add(SearchContactsEvent(_searchController.text));
    });
  }

  @override
  void dispose() {
    _createGroupBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _createGroupBloc,
      child: BlocConsumer<CreateGroupBloc, CreateGroupState>(
        listener: (context, state) {
          if (state.status == CreateGroupStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          } else if (state.status == CreateGroupStatus.success && state.groupId != null) {
            BeaverToast.show(context, '群组创建成功');
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final filteredContacts = state.contacts.where((c) => 
            c.nickname.toLowerCase().contains(state.searchQuery.toLowerCase())).toList();

          return BeaverLayout(
            title: '发起群聊',
            showBack: true,
            child: Column(
              children: [
                _buildSearchBar(),
                Expanded(child: _buildContactList(filteredContacts, state)),
                _buildBottomBar(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: '搜索联系人',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.w)),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildContactList(List<Contact> contacts, CreateGroupState state) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final isSelected = state.selectedContacts.any((c) => c.userId == contact.userId);
        return ListTile(
          leading: BeaverAvatar(url: contact.fileName, size: 40.w, nickname: contact.nickname),
          title: Text(contact.nickname),
          trailing: Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected ? Colors.orange : Colors.grey,
          ),
          onTap: () => _createGroupBloc.add(SelectContactEvent(contact)),
        );
      },
    );
  }

  Widget _buildBottomBar(CreateGroupState state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          Expanded(child: Text('已选择 ${state.selectedContacts.length} 人')),
          ElevatedButton(
            onPressed: state.selectedContacts.isEmpty ? null : () => _createGroupBloc.add(CreateGroupSubmitEvent()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
