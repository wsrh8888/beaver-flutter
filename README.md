# Beaver Flutter 项目启动指南

本项目使用 [FVM](https://fvm.app/) 进行 Flutter 版本管理。

## 1. 开发调试 (运行)

> [!IMPORTANT]
> 运行安卓前请先启动**雷电模拟器**或连接真机。

### 🤖 启动安卓 (Android)
```bash
# 运行到雷电模拟器 (推荐方式)
fvm flutter run -d android

# 如果有多个设备，指定具体 ID (如 emulator-5554)
fvm flutter run -d emulator-5554
```

### 🌐 启动浏览器 (Web)
```bash
# 运行到 Chrome 浏览网页
fvm flutter run -d web-server --web-port 8080
```
---

## 2. 打包发布 (Release)

### 🤖 安卓打包 (APK)
```bash
# 生成 release 安装包
fvm flutter build apk --release
```

### 🍎 苹果打包 (iOS)
> **提示：** 必须在 macOS 系统环境下。
```bash
fvm flutter build ios
```

---

## 3. 辅助指令 (环境维护)
```bash
# 连接雷电模拟器 (如果执行 run 找不到设备时使用)
# 命令中的 adb 请确保已加入系统环境变量，或使用全路径
adb connect 127.0.0.1:5555

# 同意安卓所有证书 (SDK 安装后必做一次)
fvm flutter doctor --android-licenses

# 清理缓存 (运行出错、图标不更新时执行)
fvm flutter clean

# 获取项目依赖
fvm flutter pub get
```
## 数据库
<!--  -->

fvm flutter pub run build_runner build --delete-conflicting-outputs