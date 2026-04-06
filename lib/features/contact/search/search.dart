import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/contact/search/bloc/bloc.dart';
import 'package:beaver/features/contact/search/bloc/event.dart';
import 'package:beaver/features/contact/search/bloc/state.dart';
import 'package:beaver/features/contact/search/data/repositories/repository.dart';
import 'package:beaver/shared/ui/cache/image.dart';
import 'package:beaver/types/cache.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class SearchContactPage extends StatefulWidget {
  const SearchContactPage({super.key});

  @override
  State<SearchContactPage> createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  final _searchController = TextEditingController();
  late SearchContactBloc _searchBloc;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    final repository = SearchContactRepository();
    _searchBloc = SearchContactBloc(repository);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchBloc.close();
    super.dispose();
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() => _isSearching = true);
      _searchBloc.add(SearchUserEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: BlocListener<SearchContactBloc, SearchContactState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            BeaverToast.show(context, state.errorMessage!);
          }
        },
        child: BeaverLayout(
          title: '添加朋友',
          showBack: true,
          isScrollable: true,
          child: Column(
            children: [
              _buildSearchBar(),
              SizedBox(height: 12.w),
              _buildSearchContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 12.w, 8.w, 12.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F2F6),
                borderRadius: BorderRadius.circular(6.w),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: const Color(0xFFB2BEC3),
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xFF2D3436),
                      ),
                      decoration: InputDecoration(
                        hintText: '账号 / 手机号 / 邮箱',
                        hintStyle: TextStyle(
                          fontSize: 15.sp,
                          color: const Color(0xFFB2BEC3),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (_) => _handleSearch(),
                      onChanged: (val) {
                        setState(() {}); // 更新清除按钮状态
                        if (val.isEmpty && _isSearching) {
                          setState(() => _isSearching = false);
                        }
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _isSearching = false);
                      },
                      child: Icon(
                        Icons.cancel,
                        color: const Color(0xFFB2BEC3),
                        size: 18.w,
                      ),
                    ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: _handleSearch,
            child: Text(
              '搜索',
              style: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFFFF7D45),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent() {
    if (_isSearching) {
      return _buildSearchResult();
    }
    return Column(
      children: [
        SizedBox(height: 32.w),
        _buildMyQrcode(),
      ],
    );
  }

  Widget _buildSearchResult() {
    return BlocBuilder<SearchContactBloc, SearchContactState>(
      builder: (context, state) {
        if (state.status == SearchContactStatus.loading) {
          return Container(
            margin: EdgeInsets.only(top: 40.w),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF7D45)),
            ),
          );
        }

        if (state.status == SearchContactStatus.success && state.user != null) {
          final user = state.user!;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10.w,
                  offset: Offset(0, 4.w),
                ),
              ],
            ),
            child: Row(
              children: [
                BeaverCachedImage(
                  fileKey: user.avatar,
                  type: CacheType.avatar,
                  width: 50.w,
                  height: 50.w,
                  borderRadius: 8.w,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.nickname,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3436),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        '海狸号: ${user.userId}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFFB2BEC3),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: () {
                    _searchBloc.add(AddFriendEvent(user.userId));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7D45),
                      borderRadius: BorderRadius.circular(16.w),
                    ),
                    child: Text(
                      '添加',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state.status == SearchContactStatus.error ||
            (state.status == SearchContactStatus.success &&
                state.user == null)) {
          return Container(
            margin: EdgeInsets.only(top: 40.w),
            child: Column(
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 64.w,
                  color: const Color(0xFFDFE6E9),
                ),
                SizedBox(height: 16.w),
                Text(
                  state.errorMessage ?? '未查找到该用户',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFFB2BEC3),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildMyQrcode() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.qr_code_2_rounded,
            size: 20.w,
            color: const Color(0xFF636E72),
          ),
          SizedBox(width: 8.w),
          Text(
            '我的扫描二维码快速添加',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF636E72)),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.keyboard_arrow_right,
            size: 20.w,
            color: const Color(0xFFB2BEC3),
          ),
        ],
      ),
    );
  }
}
