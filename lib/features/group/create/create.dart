import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/group/create/bloc/bloc.dart';
import 'package:beaver/features/group/create/bloc/event.dart';
import 'package:beaver/features/group/create/bloc/state.dart';

import 'package:beaver/types/business/contact.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
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
    _createGroupBloc = CreateGroupBloc()..add(const LoadContactsEvent());
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
      child: BlocListener<CreateGroupBloc, CreateGroupState>(
        listener: (context, state) {
          if (state.status == CreateGroupStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          } else if (state.status == CreateGroupStatus.success && state.groupId != null) {
            BeaverToast.show(context, '群组创建成功');
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<CreateGroupBloc, CreateGroupState>(
          builder: (context, state) {
            final filteredContacts = state.contacts.where((c) {
              final name = c.notice?.isNotEmpty == true ? c.notice! : c.nickname;
              return name.toLowerCase().contains(state.searchQuery.toLowerCase());
            }).toList();

            return BeaverLayout(
              title: '发起群聊',
              showBack: true,
              isScrollable: false,
              child: Column(
                children: [
                  _buildSearchBar(),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: _buildContactList(filteredContacts, state),
                    ),
                  ),
                  _buildBottomBar(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      child: Container(
        height: 40.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F2F6),
          borderRadius: BorderRadius.circular(6.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            Icon(Icons.search, color: const Color(0xFFB2BEC3), size: 20.w),
            SizedBox(width: 8.w),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 15.sp, color: const Color(0xFF2D3436)),
                decoration: InputDecoration(
                  hintText: '搜索联系人',
                  hintStyle: TextStyle(fontSize: 15.sp, color: const Color(0xFFB2BEC3)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                },
                child: Icon(Icons.cancel, color: const Color(0xFFB2BEC3), size: 18.w),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactList(List<ContactModel> contacts, CreateGroupState state) {
    if (contacts.isEmpty) {
      if (_searchController.text.isNotEmpty) {
        return Center(
          child: Text(
            '未搜索到联系人',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFFB2BEC3)),
          ),
        );
      }
      return Center(
        child: Text(
          '无联系人',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFFB2BEC3)),
        ),
      );
    }

    return ListView.separated(
      itemCount: contacts.length,
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(left: 72.w),
        child: Divider(height: 1.w, color: const Color(0xFFEBEEF5)),
      ),
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final isSelected = state.selectedContacts.any((c) => c.userId == contact.userId);
        final displayName = contact.notice?.isNotEmpty == true ? contact.notice! : contact.nickname;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _createGroupBloc.add(SelectContactEvent(contact)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
            child: Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFFFF7D45) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFF7D45) : const Color(0xFFDFE6E9),
                      width: 1.5.w,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, size: 16.w, color: Colors.white)
                      : null,
                ),
                SizedBox(width: 16.w),
                BeaverCachedImage(
                  fileKey: contact.avatar ?? contact.fileName ?? '',
                  type: CacheType.avatar,
                  width: 44.w,
                  height: 44.w,
                  borderRadius: 8.w,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2D3436),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(CreateGroupState state) {
    final count = state.selectedContacts.length;
    final hasSelection = count > 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border(top: BorderSide(color: const Color(0xFFEBEEF5), width: 1.w)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hasSelection ? '已选择 $count 人' : '请选择联系人',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: hasSelection ? FontWeight.w600 : FontWeight.w400,
                color: hasSelection ? const Color(0xFF2D3436) : const Color(0xFFB2BEC3),
              ),
            ),
            GestureDetector(
              onTap: hasSelection ? () => _createGroupBloc.add(const CreateGroupSubmitEvent()) : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
                decoration: BoxDecoration(
                  color: hasSelection ? const Color(0xFFFF7D45) : const Color(0xFFFFD1BD),
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: Text(
                  '完成${hasSelection ? ' ($count)' : ''}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
