import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/calls/history/bloc/bloc.dart';
import 'package:beaver/features/calls/history/bloc/event.dart';
import 'package:beaver/features/calls/history/bloc/state.dart';
import 'package:beaver/features/calls/history/data/repositories/repository.dart';
import 'package:beaver/features/calls/data/models/call.dart';
import 'package:beaver/shared/ui/avatar/avatar.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/toast.dart';

class CallHistoryPage extends StatefulWidget {
  const CallHistoryPage({super.key});

  @override
  State<CallHistoryPage> createState() => _CallHistoryPageState();
}

class _CallHistoryPageState extends State<CallHistoryPage> {
  late CallHistoryBloc _callHistoryBloc;

  @override
  void initState() {
    super.initState();
    _callHistoryBloc = CallHistoryBloc(CallHistoryRepository())..add(const LoadCallHistoryEvent());
  }

  @override
  void dispose() {
    _callHistoryBloc.close();
    super.dispose();
  }

  void _handleDeleteCall(String callId) {
    _callHistoryBloc.add(DeleteCallHistoryEvent(callId));
  }

  void _handleClearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清空'),
        content: const Text('确定要清空所有通话记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              _callHistoryBloc.add(const ClearCallHistoryEvent());
              Navigator.of(context).pop();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  String _formatCallTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays == 0) {
      return '今天 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '昨天 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
      return '${weekdays[time.weekday % 7]} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
    }
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:$remainingSeconds';
  }

  Widget _buildCallItem(CallHistory call) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      child: Row(
        children: [
          // 头像
          BeaverAvatar(
            url: call.isIncoming ? call.callerAvatar : call.receiverAvatar,
            size: 56.w,
          ),
          SizedBox(width: 16.w),
          
          // 通话信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      call.isIncoming ? call.callerName : call.receiverName,
                      style: TextStyle(
                        fontSize: 16.w,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (call.isMissed)
                      Text(
                        '未接',
                        style: TextStyle(
                          fontSize: 12.w,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.w),
                Row(
                  children: [
                    Icon(
                      call.callType == CallType.video ? Icons.video_call : Icons.call,
                      size: 14.w,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      call.isIncoming ? '来电' : '呼出',
                      style: TextStyle(
                        fontSize: 14.w,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (call.duration != null)
                      Row(
                        children: [
                          SizedBox(width: 8.w),
                          Text(
                            '时长 ${_formatDuration(call.duration)}',
                            style: TextStyle(
                              fontSize: 14.w,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // 时间和操作
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCallTime(call.startTime),
                style: TextStyle(
                  fontSize: 12.w,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 8.w),
              GestureDetector(
                onTap: () => _handleDeleteCall(call.id),
                child: Icon(
                  Icons.delete_outline,
                  size: 20.w,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _callHistoryBloc,
      child: BlocConsumer<CallHistoryBloc, CallHistoryState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            BeaverToast.show(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '通话记录',
            showBack: true,
            rightSlot: state.callHistoryList.isNotEmpty
                ? GestureDetector(
                    onTap: _handleClearAll,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        '清空',
                        style: TextStyle(
                          fontSize: 14.w,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  )
                : null,
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.callHistoryList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call_end,
                              size: 64.w,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 16.w),
                            Text(
                              '暂无通话记录',
                              style: TextStyle(
                                fontSize: 16.w,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: state.callHistoryList.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1.w,
                          color: Colors.grey[200],
                        ),
                        itemBuilder: (context, index) {
                          final call = state.callHistoryList[index];
                          return _buildCallItem(call);
                        },
                      ),
          );
        },
      ),
    );
  }
}
