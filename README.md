# 🦫 Beaver IM - 海狸即时通讯移动端

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.0.1-blue.svg)](VERSION)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev/)
[![QQ群](https://img.shields.io/badge/QQ群-1013328597%2B-blue.svg)](https://qm.qq.com/q/82rbf7QBzO)

> 🚀 **现代化移动端即时通讯应用** - 基于 Flutter + Dart 构建，支持 Android/iOS/Web，提供完整的社交聊天体验

**当前版本：[2.0.1](VERSION)**（以仓库根目录 [`VERSION`](VERSION) 文件为准，与 `pubspec.yaml` 同步）

[English](README_EN.md) | [中文](README.md)

---

## ✨ 核心功能

- 🔐 用户认证（注册、登录、密码找回）
- 💬 即时通讯（私聊、群聊、文本、图片、表情）
- 👥 社交功能（好友管理、二维码添加、好友备注）
- 🖼️ 多媒体支持（图片发送、文件传输、屏幕截图）
- 📱 多端同步（与桌面端数据实时同步）
- 🔄 实时通信（WebSocket长连接）

## 🛠️ 技术栈

- **Flutter** 3.x - 跨平台UI框架
- **Dart** 3.x - 类型安全的编程语言
- **flutter_bloc** - 状态管理
- **Drift** - SQLite ORM
- **WebSocket** - 实时通信
- **getIt** - 依赖注入
- **go_router** - 路由管理

---

## 📱 功能展示

### 💬 聊天功能
<div align="center">
  <img src="./assets/screenshots/messages.jpg" width="200" alt="消息列表"/>
  <img src="./assets/screenshots/chat_content.jpg" width="200" alt="聊天内容"/>
  <img src="./assets/screenshots/chat_settings.jpg" width="200" alt="聊天设置"/>
  <img src="./assets/screenshots/favorite_emojis.jpg" width="200" alt="收藏表情"/>
  <img src="./assets/screenshots/default_emojis.jpg" width="200" alt="默认表情"/>
</div>

### 👥 社交功能
<div align="center">
  <img src="./assets/screenshots/friend_list.jpg" width="200" alt="好友列表"/>
  <img src="./assets/screenshots/friend_profile.jpg" width="200" alt="好友详情"/>
  <img src="./assets/screenshots/new_friend_received.jpg" width="200" alt="收到申请"/>
  <img src="./assets/screenshots/new_friend_sent.jpg" width="200" alt="发出申请"/>
</div>

### 👥 群聊功能
<div align="center">
  <img src="./assets/screenshots/create_group.jpg" width="200" alt="创建群聊"/>
  <img src="./assets/screenshots/my_groups.jpg" width="200" alt="我的群聊"/>
</div>

### ⚙️ 系统功能
<div align="center">
  <img src="./assets/screenshots/my_profile.jpg" width="200" alt="个人中心"/>
  <img src="./assets/screenshots/general_settings.jpg" width="200" alt="通用设置"/>
  <img src="./assets/screenshots/feedback.jpg" width="200" alt="意见反馈"/>
  <img src="./assets/screenshots/camera.jpg" width="200" alt="拍照"/>
  <img src="./assets/screenshots/database.jpg" width="200" alt="数据库同步"/>
</div>

---

## 🚀 快速开始

### 环境要求

- Flutter >= 3.0.0
- Dart >= 3.0.0
- Android SDK 
- Xcode
- FVM (推荐用于 Flutter 版本管理)

---

## 🔗 相关项目

| 项目 | 仓库地址 | 说明 |
|------|----------|------|
| **beaver-server** | [GitHub](https://github.com/wsrh8888/beaver-server) \| [Gitee](https://gitee.com/dawwdadfrf/beaver-server) | 后端服务 |
| **beaver-flutter** | [GitHub](https://github.com/wsrh8888/beaver-flutter) | 移动端应用 (Flutter - 推荐) |
| **beaver-desktop** | [GitHub](https://github.com/wsrh8888/beaver-desktop) \| [Gitee](https://gitee.com/dawwdadfrf/beaver-desktop) | 桌面端应用 |
| **beaver-uniapp** | [GitHub](https://github.com/wsrh8888/beaver-uniapp) | 移动端应用 (Uniapp - 已废弃) |

## 📚 文档与帮助

- 📖 **详细文档**: [Beaver IM 文档](https://wsrh8888.github.io/beaver-docs/)
- 🎥 **视频教程**: [B站教程](https://www.bilibili.com/video/BV1HrrKYeEB4/)
- 📱 **体验包下载**: [海狸IM Android体验包](https://github.com/wsrh8888/beaver-docs/releases/download/lastest/latest.apk)
- 💬 **QQ群**:
  - [1013328597](https://qm.qq.com/q/82rbf7QBzO) - 群一 (已满)
  - [1044762885](https://qm.qq.com/q/82rbf7QBzO) - 群二
  - [1003121259](https://qm.qq.com/q/82rbf7QBzO) - 群三

## 🤝 贡献指南

我们欢迎所有形式的贡献！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## ⭐ 支持项目

如果这个项目对你有帮助，请给我们一个 ⭐ Star！

## ☕ 请作者喝杯茶

如果这个项目对你有帮助，欢迎请作者喝杯茶 ☕

<div align="center">
  <img src="./static/sponsor/wechat.jpg" width="200" alt="微信赞助码"/>
  <img src="./static/sponsor/zhifubao.jpg" width="200" alt="支付宝赞助码"/>
</div>

## 📄 开源协议

本项目基于 [MIT](LICENSE) 协议开源。

## ⭐ Star历史

[![Star History Chart](https://api.star-history.com/svg?repos=wsrh8888/beaver-flutter&type=Date)](https://star-history.com/#wsrh8888/beaver-flutter&Date)

---

<div align="center">
  <strong>Made with ❤️ by Beaver IM Team</strong><br>
  <em>企业级即时通讯平台</em>
</div>
