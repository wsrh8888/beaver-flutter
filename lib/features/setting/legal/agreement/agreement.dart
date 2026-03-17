import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beaver/features/setting/legal/agreement/bloc/bloc.dart';
import 'package:beaver/features/setting/legal/agreement/bloc/event.dart';
import 'package:beaver/features/setting/legal/agreement/bloc/state.dart';
import 'package:beaver/features/setting/legal/agreement/data/repositories/repository.dart';
import 'package:beaver/shared/ui/layout/layout.dart';
import 'package:beaver/shared/ui/toast/index.dart';

class AgreementPage extends StatefulWidget {
  const AgreementPage({super.key});

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  late AgreementBloc _agreementBloc;

  @override
  void initState() {
    super.initState();
    _agreementBloc = AgreementBloc(AgreementRepository())..add(LoadAgreementEvent());
  }

  @override
  void dispose() {
    _agreementBloc.close();
    super.dispose();
  }

  void _handleGoBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _agreementBloc,
      child: BlocConsumer<AgreementBloc, AgreementState>(
        listener: (context, state) {
          if (state.status == AgreementStatus.error) {
            BeaverToast.show(context, state.errorMessage ?? '发生错误');
          }
        },
        builder: (context, state) {
          return BeaverLayout(
            title: '服务条款',
            showBack: true,
            onBack: _handleGoBack,
            showBackground: false,
            isScrollable: true,
            child: Container(
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
                        'Beaver用户服务协议',
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
                        '更新日期：2025年1月1日',
                        style: TextStyle(
                          fontSize: 12.w,
                          color: const Color(0xFFB2BEC3),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.w),
                    // 介绍
                    Text(
                      '欢迎您使用Beaver！本协议是您与Beaver之间关于使用我们提供的产品和服务的法律协议。请您在注册和使用前仔细阅读本协议的全部内容。',
                      style: TextStyle(
                        fontSize: 14.w,
                        lineHeight: 1.6,
                        color: const Color(0xFF636E72),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 24.w),
                    // 服务介绍
                    _buildSection(
                      title: '1. 服务介绍',
                      content: 'Beaver是一款陌生人社交应用，旨在帮助用户扩展社交圈子，发现共同兴趣爱好的新朋友。我们提供以下服务：',
                      listItems: [
                        '基于兴趣和地理位置的好友推荐',
                        '一对一及群组即时通讯',
                        '分享生活动态的社区功能',
                        '用户个人资料展示和管理',
                        '基于位置的附近活动和用户发现',
                      ],
                    ),
                    // 账户注册与安全
                    _buildSection(
                      title: '2. 账户注册与安全',
                      content: '使用我们的服务，您需要：',
                      listItems: [
                        '创建账户并提供真实、准确、完整的个人资料信息。',
                        '妥善保管您的账号和密码，对通过您的账号进行的所有活动负责。',
                        '定期更新您的个人资料，确保信息的准确性。',
                        '如发现账号遭到未授权使用或存在安全漏洞，请立即通知我们。',
                      ],
                      additionalContent: '注意：您必须年满16周岁才能使用我们的服务。如您未满18周岁，请在监护人指导下使用本服务。',
                    ),
                    // 用户行为规范
                    _buildSection(
                      title: '3. 用户行为规范',
                      content: '使用Beaver时，您同意不会：',
                      listItems: [
                        '发布、传播违反国家法律法规的内容。',
                        '发布虚假、误导、欺诈或有害信息。',
                        '侵犯他人知识产权或隐私权。',
                        '骚扰、威胁或冒犯其他用户。',
                        '使用任何自动化手段或脚本访问我们的服务。',
                        '尝试干扰、破坏平台的正常运行或规避我们的安全措施。',
                      ],
                    ),
                    // 内容规范
                    _buildSection(
                      title: '4. 内容规范',
                      content: '您通过Beaver创建、上传、发布的所有内容必须：',
                      listItems: [
                        '遵守相关法律法规。',
                        '不包含色情、暴力、歧视或仇恨言论。',
                        '不侵犯第三方的知识产权、肖像权、名誉权等合法权益。',
                        '不包含广告、垃圾信息或恶意软件链接。',
                      ],
                      additionalContent: '我们有权但无义务审核用户内容，并可自行决定删除或拒绝任何违反本协议的内容。',
                    ),
                    // 知识产权
                    _buildSection(
                      title: '5. 知识产权',
                      content: '关于知识产权，请注意以下几点：',
                      listItems: [
                        'Beaver及其标识、图标、设计等所有相关的知识产权归我们所有。',
                        '您保留您创建并分享内容的知识产权，但授予我们全球性、免费、非独占的许可，允许我们使用、复制、修改、展示和分发您的内容。',
                        '如您认为平台上的内容侵犯了您的知识产权，请通过下方联系方式告知我们。',
                      ],
                    ),
                    // 服务变更与终止
                    _buildSection(
                      title: '6. 服务变更与终止',
                      content: '关于我们服务的变更和终止规则：',
                      listItems: [
                        '我们可能会不时更新或修改服务内容、功能和收费标准。',
                        '我们保留在任何时候暂停或终止部分或全部服务的权利。',
                        '如您违反本协议，我们可能会限制、暂停或终止您的账户访问权限。',
                        '您可以随时停止使用我们的服务，或按照平台提供的方式注销您的账户。',
                      ],
                    ),
                    // 免责声明
                    _buildSection(
                      title: '7. 免责声明',
                      content: '使用Beaver时，请理解并同意：',
                      listItems: [
                        '我们的服务按"现状"和"可用"提供，不提供任何明示或暗示的保证。',
                        '我们不对用户之间的互动和交流负责，请谨慎分享个人信息。',
                        '我们不对因网络故障、系统维护、不可抗力等导致的服务中断或数据丢失负责。',
                        '我们对服务中第三方提供的内容、网站或服务不承担责任。',
                      ],
                    ),
                    // 协议修改
                    _buildSection(
                      title: '8. 协议修改',
                      content: '我们可能会不时修改本协议。当我们进行重大变更时，会在应用内发布通知。您继续使用我们的服务即表示您接受修改后的条款。',
                    ),
                    // 联系方式
                    Container(
                      margin: EdgeInsets.only(top: 32.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '如果您对我们的服务条款有任何疑问或建议，请通过以下方式与我们联系：',
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
          );
        },
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
