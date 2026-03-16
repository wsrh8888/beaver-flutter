import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/privacy/privacy_page/bloc/bloc.dart';
import 'package:beaver/features/privacy/privacy_page/bloc/event.dart';
import 'package:beaver/features/privacy/privacy_page/bloc/state.dart';
import 'package:beaver/features/privacy/privacy_page/data/repositories/repository.dart';
import 'package:beaver/shared/ui/header/header.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late PrivacyBloc _privacyBloc;

  @override
  void initState() {
    super.initState();
    _privacyBloc = PrivacyBloc(PrivacyRepository())..add(LoadPrivacyPolicyEvent());
  }

  @override
  void dispose() {
    _privacyBloc.close();
    super.dispose();
  }

  void _handleGoBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: BlocProvider.value(
        value: _privacyBloc,
        child: BlocConsumer<PrivacyBloc, PrivacyState>(
          listener: (context, state) {
            if (state.status == PrivacyStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? '发生错误')),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // 头部
                BeaverHeader(
                  title: '隐私政策',
                  showBack: true,
                  onBack: _handleGoBack,
                ),
                // 内容
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Container(
                      padding: EdgeInsets.all(32.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: Offset(0, 4.w),
                            blurRadius: 20.w,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 标题
                          Center(
                            child: Text(
                              'Beaver隐私政策',
                              style: TextStyle(
                                fontSize: 24.w,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3436),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.w),
                          // 更新日期
                          Center(
                            child: Text(
                              '更新日期：2025年4月3日',
                              style: TextStyle(
                                fontSize: 12.w,
                                color: const Color(0xFFB2BEC3),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.w),
                          // 介绍
                          Text(
                            'Beaver重视您的隐私。本隐私政策说明了我们如何收集、使用、披露、处理和保护您在使用我们的服务时所提供的信息。请您仔细阅读本政策，了解我们的隐私惯例。',
                            style: TextStyle(
                              fontSize: 14.w,
                              lineHeight: 1.6,
                              color: const Color(0xFF636E72),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 24.w),
                          // 我们收集的信息
                          _buildSection(
                            title: '1. 我们收集的信息',
                            content: '我们可能会收集以下类型的信息：',
                            listItems: [
                              '您提供的个人信息：注册时的手机号码、密码、个人资料（如头像、昵称、性别、生日）等。',
                              '您创建的内容：发布的动态、评论、消息等。',
                              '设备信息：设备型号、操作系统版本、设备标识符、网络信息等。',
                              '位置信息：在您授权的情况下，我们可能会收集您的精确或大致位置信息。',
                              '使用数据：应用使用频率、崩溃数据、性能数据等信息。',
                            ],
                          ),
                          // 我们如何使用信息
                          _buildSection(
                            title: '2. 我们如何使用信息',
                            content: '我们使用收集的信息用于：',
                            listItems: [
                              '提供、维护和改进我们的服务。',
                              '处理和完成您的交易。',
                              '向您发送技术通知、更新、安全警报和支持信息。',
                              '提供客户服务并回应您的请求。',
                              '根据您的兴趣和位置向您推荐好友和内容。',
                              '监控和分析趋势、使用情况和活动。',
                              '遵守法律义务和执行我们的服务条款。',
                            ],
                          ),
                          // 信息共享与披露
                          _buildSection(
                            title: '3. 信息共享与披露',
                            content: '我们可能在以下情况下共享您的信息：',
                            listItems: [
                              '根据您的选择在平台上公开分享您的个人资料和内容。',
                              '与提供服务所必需的第三方服务提供商共享。',
                              '在法律要求或允许的情况下，响应法律程序或政府请求。',
                              '保护Beaver、我们的用户或公众的权利和安全。',
                              '在涉及合并、收购、资产出售或类似交易时与相关方共享。',
                            ],
                            additionalContent: '注意：我们不会向第三方出售您的个人信息。',
                          ),
                          // 数据安全
                          _buildSection(
                            title: '4. 数据安全',
                            content: '我们采取合理的技术、管理和物理措施来保护您的信息不被未经授权的访问、使用或披露。但请了解，互联网传输方式无法保证100%的安全性。',
                          ),
                          // 信息存储与国际传输
                          _buildSection(
                            title: '5. 信息存储与国际传输',
                            content: '我们可能在您所在国家/地区以外的服务器上处理和存储您的信息。使用我们的服务，即表示您同意这种国际传输和处理。',
                          ),
                          // 您的权利与选择
                          _buildSection(
                            title: '6. 您的权利与选择',
                            content: '关于您的个人信息，您有权：',
                            listItems: [
                              '访问和查看您的个人资料信息。',
                              '更正不准确或不完整的信息。',
                              '删除您的账户和相关数据。',
                              '控制通知、位置服务和其他权限设置。',
                            ],
                          ),
                          // 儿童隐私
                          _buildSection(
                            title: '7. 儿童隐私',
                            content: '我们的服务不面向16岁以下的儿童。如果我们发现未经父母同意收集了16岁以下儿童的个人信息，我们将采取措施删除这些信息。',
                          ),
                          // 隐私政策的变更
                          _buildSection(
                            title: '8. 隐私政策的变更',
                            content: '我们可能会不时更新本隐私政策。当我们进行重大变更时，会在应用内通知您并获取您的同意（如适用）。建议您定期查看本政策以了解最新信息。',
                          ),
                          // 联系方式
                          Container(
                            margin: EdgeInsets.only(top: 32.w),
                            padding: EdgeInsets.only(top: 24.w),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: const Color(0xFFEBEEF5),
                                  width: 1.w,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '如果您对我们的隐私政策有任何疑问或建议，请通过以下方式与我们联系：',
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    lineHeight: 1.6,
                                    color: const Color(0xFF636E72),
                                  ),
                                ),
                                SizedBox(height: 8.w),
                                Text(
                                  'support@beaver.com',
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    lineHeight: 1.6,
                                    color: const Color(0xFFFF7D45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    List<String>? listItems,
    String? additionalContent,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.w,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 12.w),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.w,
              lineHeight: 1.6,
              color: const Color(0xFF636E72),
            ),
            textAlign: TextAlign.justify,
          ),
          if (listItems != null && listItems.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 12.w, bottom: 16.w),
              child: Column(
                children: listItems.map((item) => _buildListItem(item)).toList(),
              ),
            ),
          if (additionalContent != null)
            Text(
              additionalContent,
              style: TextStyle(
                fontSize: 14.w,
                lineHeight: 1.6,
                color: const Color(0xFF636E72),
              ),
              textAlign: TextAlign.justify,
            ),
        ],
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.w),
      padding: EdgeInsets.only(left: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            margin: EdgeInsets.only(top: 7.w, right: 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.w),
              color: const Color(0xFFFF7D45),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.w,
                lineHeight: 1.6,
                color: const Color(0xFF636E72),
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
