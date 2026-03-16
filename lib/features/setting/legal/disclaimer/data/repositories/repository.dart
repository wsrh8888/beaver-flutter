import 'package:beaver/features/setting/legal/disclaimer/data/models/disclaimer.dart';

class DisclaimerRepository {
  Future<List<ProjectLink>> getProjectLinks() async {
    // 模拟获取项目链接
    await Future.delayed(const Duration(seconds: 1));
    return [
      ProjectLink(
        name: '移动�?,
        description: 'uni-app 跨平台应�?,
        url: 'https://github.com/wsrh8888/beaver-mobile',
        icon: 'mobile',
      ),
      ProjectLink(
        name: '服务�?,
        description: 'Go-Zero 微服务架�?,
        url: 'https://github.com/wsrh8888/beaver-server',
        icon: 'server',
      ),
      ProjectLink(
        name: 'PC�?,
        description: 'Electron + Vue3 桌面应用',
        url: 'https://github.com/wsrh8888/beaver-desktop',
        icon: 'desktop',
      ),
      ProjectLink(
        name: '项目文档',
        description: '开发文档和使用指南',
        url: 'https://wsrh8888.github.io/beaver-docs/',
        icon: 'doc',
      ),
      ProjectLink(
        name: '视频教程',
        description: 'B站手把手搭建教程',
        url: 'https://www.bilibili.com/video/BV1HrrKYeEB4/',
        icon: 'video',
      ),
      ProjectLink(
        name: 'QQ交流�?,
        description: '1013328597',
        url: '',
        icon: 'github',
      ),
    ];
  }

  Future<AuthorInfo> getAuthorInfo() async {
    // 模拟获取作者信�?
    await Future.delayed(const Duration(seconds: 1));
    return AuthorInfo(
      name: 'wsrh8888',
      description: '全栈开发�?,
      githubUrl: 'https://github.com/wsrh8888',
    );
  }
}

