import 'package:beaver/features/moment/detail/data/models/moment.dart';

class MomentRepository {
  Future<List<Moment>> getMoments() async {
    // 模拟获取朋友圈数�?
    await Future.delayed(const Duration(seconds: 1));
    return [
      Moment(
        id: '1',
        userName: '张三',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait&size=512x512',
        content: '今天天气真好，出去散步了�?,
        files: [
          MomentFile('https://neeko-copilot.bytedance.net/api/text2image?prompt=park%20scenery&size=512x512'),
          MomentFile('https://neeko-copilot.bytedance.net/api/text2image?prompt=sunny%20day&size=512x512'),
        ],
        likes: [
          MomentLike('2', '李四'),
          MomentLike('3', '王五'),
        ],
        createdAt: '2024-01-01 10:00:00',
      ),
      Moment(
        id: '2',
        userName: '李四',
        fileName: 'https://neeko-copilot.bytedance.net/api/text2image?prompt=avatar%20portrait%20female&size=512x512',
        content: '分享一张美食照片，看起来很美味吧！',
        files: [
          MomentFile('https://neeko-copilot.bytedance.net/api/text2image?prompt=delicious%20food&size=512x512'),
          MomentFile('https://neeko-copilot.bytedance.net/api/text2image?prompt=restaurant%20dish&size=512x512'),
          MomentFile('https://neeko-copilot.bytedance.net/api/text2image?prompt=dessert&size=512x512'),
        ],
        likes: [
          MomentLike('1', '张三'),
        ],
        createdAt: '2024-01-01 09:30:00',
      ),
    ];
  }

  Future<bool> toggleLike(String momentId, bool status) async {
    // 模拟点赞操作
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

