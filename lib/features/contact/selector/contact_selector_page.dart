import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/contact/selector/bloc/bloc.dart';
import 'package:beaver/features/contact/selector/bloc/event.dart';
import 'package:beaver/features/contact/selector/bloc/state.dart';
import 'package:beaver/types/business/contact.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/layout/layout.dart';

class ContactSelectorPage extends StatefulWidget {
  final String title;
  final List<ContactModel> initialSelected;
  final List<String> disabledUserIds;

  const ContactSelectorPage({
    super.key,
    this.title = '选择联系人',
    this.initialSelected = const [],
    this.disabledUserIds = const [],
  });

  @override
  State<ContactSelectorPage> createState() => _ContactSelectorPageState();
}

class _ContactSelectorPageState extends State<ContactSelectorPage> {
  late ContactSelectorBloc _bloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = ContactSelectorBloc(initialSelected: widget.initialSelected);
    _searchController.addListener(() {
      _bloc.add(SearchContactsEvent(_searchController.text));
    });
  }

  @override
  void dispose() {
    _bloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<ContactSelectorBloc, ContactSelectorState>(
        builder: (context, state) {
          final filteredContacts = state.contacts.where((c) {
            final name = c.notice?.isNotEmpty == true ? c.notice! : c.nickname;
            return name.toLowerCase().contains(state.searchQuery.toLowerCase());
          }).toList();

          return BeaverLayout(
            title: widget.title,
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

  Widget _buildContactList(List<ContactModel> contacts, ContactSelectorState state) {
    if (contacts.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isNotEmpty ? '未搜索到联系人' : '无联系人',
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
        final isDisabled = widget.disabledUserIds.contains(contact.userId);
        final isSelected = state.selectedContacts.any((c) => c.userId == contact.userId);
        final displayName = contact.notice?.isNotEmpty == true ? contact.notice! : contact.nickname;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isDisabled ? null : () => _bloc.add(SelectContactEvent(contact)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
            child: Row(
              children: [
                Opacity(
                  opacity: isDisabled ? 0.3 : 1.0,
                  child: Container(
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
                ),
                SizedBox(width: 16.w),
                Opacity(
                  opacity: isDisabled ? 0.5 : 1.0,
                  child: BeaverCachedImage(
                    fileUrl: contact.avatar ?? contact.fileName ?? '',
                    type: CacheType.avatar,
                    width: 44.w,
                    height: 44.w,
                    borderRadius: 8.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: isDisabled ? const Color(0xFFB2BEC3) : const Color(0xFF2D3436),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isDisabled)
                  Text(
                    '已在通话中',
                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFFB2BEC3)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(ContactSelectorState state) {
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
              onTap: hasSelection ? () => Navigator.of(context).pop(state.selectedContacts) : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
                decoration: BoxDecoration(
                  color: hasSelection ? const Color(0xFFFF7D45) : const Color(0xFFFFD1BD),
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: Text(
                  '确定${hasSelection ? ' ($count)' : ''}',
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
