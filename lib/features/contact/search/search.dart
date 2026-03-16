import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/contact/search/bloc/bloc.dart';
import 'package:beaver/features/contact/search/bloc/event.dart';
import 'package:beaver/features/contact/search/bloc/state.dart';
import 'package:beaver/features/contact/search/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';

class SearchFriendPage extends StatefulWidget {
  const SearchFriendPage({super.key});

  @override
  State<SearchFriendPage> createState() => _SearchFriendPageState();
}

class _SearchFriendPageState extends State<SearchFriendPage> {
  late SearchFriendBloc _searchFriendBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchFriendBloc = SearchFriendBloc(SearchFriendRepository());
  }

  @override
  void dispose() {
    _searchFriendBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _updateSearchQuery(String query) {
    _searchFriendBloc.add(UpdateSearchQueryEvent(query));
  }

  void _performSearch() {
    _searchFriendBloc.add(PerformSearchEvent());
  }

  void _scanCode() {
    _searchFriendBloc.add(ScanCodeEvent());
  }

  void _goToDetail(String userId) {
    _searchFriendBloc.add(GoToDetailEvent(userId));
  }

  void _sendFriendRequest(String friendId) {
    _searchFriendBloc.add(SendFriendRequestEvent(friendId, '我是你的好友'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchFriendBloc,
      child: BlocConsumer<SearchFriendBloc, SearchFriendState>(
        listener: (context, state) {
          if (state.status == SearchFriendStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? '发生错误')),
            );
          } else if (state.status == SearchFriendStatus.success && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
            if (state.showResult == false) {
              _searchController.clear();
            }
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '添加好友',
            showBack: true,
            showBackground: false,
            isScrollable: true,
            child: Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // 搜索区域
                  Container(
                    margin: EdgeInsets.only(bottom: 24.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: Row(
                      children: [
                        // 搜索图标
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Icon(
                            Icons.search,
                            size: 24.w,
                            color: const Color(0xFFB2BEC3),
                          ),
                        ),
                        // 输入�?
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _updateSearchQuery,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '输入邮箱搜索好友',
                              hintStyle: TextStyle(
                                fontSize: 14.w,
                                color: const Color(0xFFB2BEC3),
                              ),
                            ),
                          ),
                        ),
                        // 搜索按钮
                        GestureDetector(
                          onTap: _performSearch,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              '搜索',
                              style: TextStyle(
                                fontSize: 14.w,
                                color: const Color(0xFFFF7D45),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 初始状态（未搜索）
                  if (!state.showResult)
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            offset: Offset(0, 4.w),
                            blurRadius: 12.w,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // 添加方式
                          GestureDetector(
                            onTap: _scanCode,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.w),
                              child: Row(
                                children: [
                                  // 图标
                                  Container(
                                    width: 48.w,
                                    height: 48.w,
                                    margin: EdgeInsets.only(right: 16.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFE6D9),
                                      borderRadius: BorderRadius.circular(12.w),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.qr_code_scanner,
                                      size: 24.w,
                                      color: const Color(0xFFFF7D45),
                                    ),
                                  ),
                                  // 信息
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '扫一�?,
                                          style: TextStyle(
                                            fontSize: 16.w,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF2D3436),
                                          ),
                                        ),
                                        Text(
                                          '扫描好友的二维码添加',
                                          style: TextStyle(
                                            fontSize: 14.w,
                                            color: const Color(0xFF636E72),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 箭头
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.w,
                                    color: const Color(0xFFB2BEC3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // 搜索结果状�?
                  if (state.showResult && state.searchResult != null)
                    Container(
                      padding: EdgeInsets.all(24.w),
                      margin: EdgeInsets.only(top: 24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            offset: Offset(0, 4.w),
                            blurRadius: 12.w,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // 搜索结果
                          GestureDetector(
                            onTap: () => _goToDetail(state.searchResult!.userId),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.w),
                              child: Row(
                                children: [
                                  // 头像
                                  Container(
                                    margin: EdgeInsets.only(right: 16.w),
                                    child: BeaverAvatar(
                                      url: state.searchResult!.fileName,
                                      size: 48.w,
                                    ),
                                  ),
                                  // 信息
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.searchResult!.nickname,
                                          style: TextStyle(
                                            fontSize: 16.w,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF2D3436),
                                          ),
                                        ),
                                        Text(
                                          'ID: ${state.searchResult!.userId}',
                                          style: TextStyle(
                                            fontSize: 14.w,
                                            color: const Color(0xFF636E72),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 提示
                                  Row(
                                    children: [
                                      Text(
                                        '点击查看详情',
                                        style: TextStyle(
                                          fontSize: 14.w,
                                          color: const Color(0xFFFF7D45),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14.w,
                                        color: const Color(0xFFFF7D45),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 分割�?
                          Container(
                            height: 1.w,
                            color: const Color(0xFFEBEEF5),
                            margin: EdgeInsets.symmetric(vertical: 16.w),
                          ),
                          // 添加好友按钮
                          GestureDetector(
                            onTap: () => _sendFriendRequest(state.searchResult!.userId),
                            child: Container(
                              height: 48.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF7D45),
                                borderRadius: BorderRadius.circular(24.w),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '添加好友',
                                style: TextStyle(
                                  fontSize: 16.w,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

