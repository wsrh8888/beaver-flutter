import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/group/create/bloc/bloc.dart';
import 'package:beaver/features/group/create/bloc/event.dart';
import 'package:beaver/features/group/create/bloc/state.dart';
import 'package:beaver/features/group/create/data/repositories/repository.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
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
  bool _showQuickJump = false;
  String _currentLetter = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _createGroupBloc = CreateGroupBloc(CreateGroupRepository())..add(LoadContactsEvent());
    _searchController.addListener(() {
      _createGroupBloc.add(SearchContactsEvent(_searchController.text));
    });
  }

  @override
  void dispose() {
    _createGroupBloc.close();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _handleSelect(Contact contact) {
    _createGroupBloc.add(SelectContactEvent(contact));
  }

  bool _isSelected(String userId) {
    return context.read<CreateGroupBloc>().state.selectedContacts.any(
          (contact) => contact.userId == userId,
        );
  }

  void _createGroup() {
    _createGroupBloc.add(CreateGroupSubmitEvent());
  }

  void _handleIndexTouch(String letter) {
    setState(() {
      _currentLetter = letter;
      _showQuickJump = true;
    });

    // 模拟滚动到对应字�?section
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _showQuickJump = false;
      });
    });
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
            // 分组联系�?
            final groupedContacts = <String, List<Contact>>{};
            for (final contact in state.contacts) {
              if (contact.nickname.toLowerCase().contains(state.searchQuery.toLowerCase())) {
                final firstLetter = contact.nickname[0].toUpperCase();
                if (!groupedContacts.containsKey(firstLetter)) {
                  groupedContacts[firstLetter] = [];
                }
                groupedContacts[firstLetter]!.add(contact);
              }
            }

            // 生成索引列表
            final indexList = groupedContacts.keys.toList()..sort();

            return BeaverLayout(
              title: '发起群聊',
              showBack: true,
              onBack: _goBack,
              showBackground: false,
              isScrollable: false,
              child: Column(
                children: [
                // 搜索�?
                Container(
                  padding: EdgeInsets.all(16.w),
                  child: Container(
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 12.w),
                        Icon(
                          Icons.search,
                          size: 20.w,
                          color: const Color(0xFFB2BEC3),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '搜索',
                              hintStyle: TextStyle(
                                fontSize: 14.w,
                                color: const Color(0xFFB2BEC3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 联系人列�?
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: groupedContacts.length,
                        itemBuilder: (context, index) {
                          final letter = indexList[index];
                          final contacts = groupedContacts[letter]!;
                          return Column(
                            children: [
                              // 字母标题
                              Container(
                                height: 32.w,
                                padding: EdgeInsets.only(left: 16.w),
                                alignment: Alignment.centerLeft,
                                color: const Color(0xFFF0F2F5),
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: 12.w,
                                    color: const Color(0xFF636E72),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              // 联系人列�?
                              ...contacts.map((contact) => GestureDetector(
                                    onTap: () => _handleSelect(contact),
                                    child: Container(
                                      height: 60.w,
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: const Color(0xFFEBEEF5),
                                            width: 1.w,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          // 头像
                                          BeaverAvatar(
                                            url: contact.fileName,
                                            size: 44.w,
                                          ),
                                          SizedBox(width: 12.w),
                                          // 信息
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  contact.nickname,
                                                  style: TextStyle(
                                                    fontSize: 14.w,
                                                    color: const Color(0xFF2D3436),
                                                  ),
                                                ),
                                                Text(
                                                  contact.status,
                                                  style: TextStyle(
                                                    fontSize: 12.w,
                                                    color: const Color(0xFFB2BEC3),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // 复选框
                                          Container(
                                            width: 24.w,
                                            height: 24.w,
                                            decoration: BoxDecoration(
                                              color: _isSelected(contact.userId)
                                                  ? const Color(0xFFFF7D45)
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.circular(12.w),
                                              border: Border.all(
                                                color: _isSelected(contact.userId)
                                                    ? const Color(0xFFFF7D45)
                                                    : const Color(0xFFB2BEC3),
                                                width: 2.w,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: _isSelected(contact.userId)
                                                ? Icon(
                                                    Icons.check,
                                                    size: 16.w,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          );
                        },
                      ),
                      // 字母索引�?
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 24.w,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: indexList.map((letter) => GestureDetector(
                                  onTap: () => _handleIndexTouch(letter),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 2.w),
                                    child: Text(
                                      letter,
                                      style: TextStyle(
                                        fontSize: 12.w,
                                        color: const Color(0xFF636E72),
                                      ),
                                    ),
                                  ),
                                )).toList(),
                          ),
                        ),
                      ),
                      // 快速跳转提�?
                      if (_showQuickJump)
                        Positioned(
                          top: MediaQuery.of(context).size.height / 2 - 50.w,
                          left: MediaQuery.of(context).size.width / 2 - 50.w,
                          child: Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(50.w),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _currentLetter,
                              style: TextStyle(
                                fontSize: 48.w,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // 底部操作�?
                Container(
                  height: 100.w,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFEBEEF5),
                        width: 1.w,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // 已选择的头�?
                      Container(
                        width: 120.w,
                        child: Row(
                          children: [
                            ...state.selectedContacts.take(3).map((contact) => Container(
                                  margin: EdgeInsets.only(right: 8.w),
                                  child: BeaverAvatar(
                                    url: contact.fileName,
                                    size: 40.w,
                                  ),
                                )),
                            if (state.selectedContacts.length > 3)
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F2F5),
                                  borderRadius: BorderRadius.circular(20.w),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '+${state.selectedContacts.length - 3}',
                                  style: TextStyle(
                                    fontSize: 12.w,
                                    color: const Color(0xFF636E72),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // 完成按钮
                      Expanded(
                        child: GestureDetector(
                          onTap: state.selectedContacts.isEmpty ? null : _createGroup,
                          child: Container(
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: state.selectedContacts.isEmpty
                                  ? const Color(0xFFB2BEC3)
                                  : const Color(0xFFFF7D45),
                              borderRadius: BorderRadius.circular(24.w),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '完成${state.selectedContacts.isEmpty ? '' : '(${state.selectedContacts.length}�?'}',
                              style: TextStyle(
                                fontSize: 16.w,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

