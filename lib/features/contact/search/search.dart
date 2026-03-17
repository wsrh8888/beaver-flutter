import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/contact/search/bloc/bloc.dart';
import 'package:beaver/features/contact/search/bloc/event.dart';
import 'package:beaver/features/contact/search/bloc/state.dart';
import 'package:beaver/features/contact/search/data/repositories/repository.dart';
import 'package:beaver/core/database/database.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
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

  @override
  void initState() {
    super.initState();
    final database = AppDatabase.instance;
    final repository = SearchContactRepository(database);
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
      _searchBloc.add(SearchUserEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: BeaverLayout(
        title: '搜索好友',
        showBack: true,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildSearchBar(),
              SizedBox(height: 20.w),
              _buildSearchResult(),
              SizedBox(height: 40.w),
              _buildMyQrcode(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey, size: 20.w),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '搜索手机号/邮箱/海狸号',
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: (_) => _handleSearch(),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {});
              },
              child: Icon(Icons.clear, color: Colors.grey, size: 20.w),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResult() {
    return BlocBuilder<SearchContactBloc, SearchContactState>(
      builder: (context, state) {
        if (state.status == SearchContactStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == SearchContactStatus.success && state.user != null) {
          final user = state.user!;
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.w),
            ),
            child: Row(
              children: [
                BeaverAvatar(url: user.avatar, size: 48.w, name: user.nickname),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.nickname, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      if (user.bio != null)
                        Text(user.bio!, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _searchBloc.add(AddFriendEvent(user.userId));
                  },
                  child: const Text('添加'),
                ),
              ],
            ),
          );
        }

        if (state.status == SearchContactStatus.error) {
          return Center(child: Text(state.errorMessage ?? '搜索失败'));
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildMyQrcode() {
    return Column(
      children: [
        const Text('我的二维码', style: TextStyle(color: Colors.grey)),
        SizedBox(height: 12.w),
        Container(
          width: 200.w,
          height: 200.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.w),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_2, size: 120.w, color: Colors.orange),
              SizedBox(height: 12.w),
              const Text('扫一扫，加我好友', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
