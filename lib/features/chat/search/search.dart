import 'package:beaver/api/chat.dart';
import 'package:beaver/router/routes.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';
import 'package:beaver/types/api/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChatSearchPage extends StatefulWidget {
  const ChatSearchPage({super.key});

  @override
  State<ChatSearchPage> createState() => _ChatSearchPageState();
}

class _ChatSearchPageState extends State<ChatSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ISearchMessageItem> _results = [];
  bool _loading = false;
  bool _searched = false;
  int _page = 1;
  int _total = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search({bool refresh = true}) async {
    final keyword = _controller.text.trim();
    if (keyword.isEmpty) {
      BeaverToast.show(context, '请输入关键词');
      return;
    }

    setState(() {
      _loading = true;
      _searched = true;
      if (refresh) {
        _page = 1;
        _results.clear();
      }
    });

    final res = await searchMessagesApi(
      ISearchMessagesReq(keyword: keyword, page: _page, limit: 20),
    );

    if (!mounted) return;

    if (res.code == 0 && res.result != null) {
      setState(() {
        if (refresh) {
          _results
            ..clear()
            ..addAll(res.result!.list);
        } else {
          _results.addAll(res.result!.list);
        }
        _total = res.result!.count;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      BeaverToast.show(context, res.msg.isNotEmpty ? res.msg : '搜索失败');
    }
  }

  void _openMessage(ISearchMessageItem item) {
    context.push('${AppRoutes.chatDetail}?id=${item.conversationId}');
  }

  @override
  Widget build(BuildContext context) {
    return BeaverLayout(
      title: '搜索消息',
      showBack: true,
      isScrollable: false,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '输入关键词',
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFFB2BEC3),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.w),
                        borderSide: const BorderSide(color: Color(0xFFEBEEF5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.w),
                        borderSide: const BorderSide(color: Color(0xFFEBEEF5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.w),
                        borderSide: const BorderSide(color: Color(0xFFFF7D45)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.w,
                      ),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: _loading ? null : () => _search(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.w,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF7D45), Color(0xFFE86835)],
                      ),
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: Text(
                      '搜索',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_loading && _results.isEmpty)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_searched && _results.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  '未找到相关消息',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF636E72),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: _results.length + (_results.length < _total ? 1 : 0),
                separatorBuilder: (_, __) => Divider(
                  height: 1.w,
                  color: const Color(0xFFEBEEF5),
                ),
                itemBuilder: (context, index) {
                  if (index >= _results.length) {
                    return TextButton(
                      onPressed: _loading
                          ? null
                          : () {
                              _page += 1;
                              _search(refresh: false);
                            },
                      child: const Text('加载更多'),
                    );
                  }

                  final item = _results[index];
                  return GestureDetector(
                    onTap: () => _openMessage(item),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.preview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF2D3436),
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 6.w),
                          Text(
                            '${item.senderName.isNotEmpty ? item.senderName : '未知用户'} · ${item.conversationId}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
