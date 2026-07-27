# 🤝 Contributing to Beaver Flutter

感谢你对 Beaver Flutter 移动端项目的贡献！本文说明贡献方式与开发规范。

## 📋 目录

- [如何贡献](#如何贡献)
- [开发环境](#开发环境)
- [编码规范](#编码规范)
- [提交规范](#提交规范)
- [Pull Request 流程](#pull-request-流程)

## 🎯 如何贡献

### 🐛 报告 Bug

提交前请先搜索已有 Issue，避免重复。

**Bug 报告模板：**

```markdown
## Bug 描述
简要说明问题

## 复现步骤
1. ...
2. ...

## 期望行为
应该发生什么

## 实际行为
实际发生了什么

## 环境
- OS: [Android / iOS / Web]
- Flutter Version: [如 3.x]
- Beaver Flutter Version: [VERSION 文件版本]
- 设备型号: [可选]

## 附加信息
日志、截图等
```

### 💡 功能建议

```markdown
## 问题背景
希望解决什么问题

## 建议方案
描述期望实现

## 替代方案
其他可行思路（可选）
```

### 🔧 代码贡献

1. **Fork** 仓库
2. **创建** 特性分支
3. **开发** 并自测
4. **提交** Pull Request

## 🛠️ 开发环境

### 环境要求

- Flutter >= 3.x
- Dart >= 3.x
- Android Studio / Xcode（真机或模拟器调试）

### 本地启动

```bash
git clone https://github.com/YOUR_USERNAME/beaver-flutter.git
cd beaver-flutter
flutter pub get
flutter run
```

### 常用命令

```bash
flutter analyze          # 静态分析
flutter test             # 运行测试
flutter build apk        # Android 构建
```

## 📝 编码规范

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 与项目现有风格
- 文件名使用 `snake_case`
- 状态管理使用 `flutter_bloc`，路由使用 `go_router`
- 本地数据库使用 Drift，遵循现有 model / repository 分层
- 新增 API 调用放在对应 feature 或 core 层，保持类型安全

### 目录结构（简要）

```
lib/
├── core/           # 网络、存储、通用能力
├── features/       # 业务功能模块
├── store/          # 全局状态
└── main.dart
```

## 📝 提交规范

建议使用 `[type] 描述` 格式，与仓库历史保持一致：

```
[feat] 语音消息播放优化
[fix] 群成员列表刷新异常
[docs] 更新 README 截图说明
[refactor] 会话列表逻辑整理
```

## 🔄 Pull Request 流程

### 提交前检查

- [ ] `flutter analyze` 无新增 error
- [ ] 相关功能已在目标平台自测（Android / iOS 至少其一）
- [ ] 未引入无关改动
- [ ] 必要时更新 README 或 VERSION

### PR 描述

```markdown
## 变更说明
简要描述改动内容与动机

## 变更类型
- [ ] Bug 修复
- [ ] 新功能
- [ ] 重构
- [ ] 文档

## 测试说明
说明如何验证本次改动
```

## 🆘 获取帮助

- **Issues**: [GitHub Issues](https://github.com/wsrh8888/beaver-flutter/issues)
- **Email**: [751135385@qq.com](mailto:751135385@qq.com)
- **QQ 群**: [1013328597](https://qm.qq.com/q/82rbf7QBzO)

---

感谢为 Beaver IM 移动端做出贡献！🦫
