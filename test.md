beaver-flutter/
├── android/                    # Android 平台特定代码
├── ios/                        # iOS 平台特定代码
├── lib/                        # Flutter 核心代码
│   ├── main.dart               # 应用入口文件，启动全局初始化
│   ├── app/                    # 应用入口组件
│   │   └── app.dart            # 根组件，负责全局 Provider/Bloc 初始化
│   ├── core/                   # 核心基础设施 (不随业务改变)
│   │   ├── network/            # 网络相关
│   │   │   ├── api/            # HTTP/gRPC 客户端及基础配置
│   │   │   └── websocket/      # WS 连接、心跳、重连管理
│   │   ├── database/           # 本地持久化 (Isar)
│   │   │   ├── isar_helper.dart # 数据库初始化与多实例管理 (Multi-Account)
│   │   │   └── collections/    # Isar 集合定义 (Schemas)
│   │   ├── sync/               # 数据同步核心 (对标商业化 IM)
│   │   │   ├── sync_manager.dart # 协调全局增量同步
│   │   │   ├── sync_task.dart    # 抽象同步任务 (User, Chat, Group)
│   │   │   └── message_queue.dart # 同步期间的实时消息缓冲区
│   │   ├── router/             # GoRouter 配置
│   │   ├── theme/              # 设计系统主题定义
│   │   ├── constants/          # 全局枚举、协议常量
│   │   └── error/              # 业务错误码与全局异常捕获
│   ├── data/                   # 全局数据协议
│   │   ├── models/             # 全局 DTO/Protobuf 定义
│   │   └── repositories/       # 数据仓库基础类
│   ├── features/               # 业务模块 (Feature-based)
│   │   ├── auth/               # 认证：登录、注册、Token管理
│   │   ├── chat/               # 聊天：核心消息收发、长连接
│   │   │   ├── bloc/           # 状态管理
│   │   │   ├── domain/         # 业务领域
│   │   │   │   ├── entities/   # 纯业务实体
│   │   │   │   └── usecases/   # 业务逻辑：发送消息、撤回、拉取历史
│   │   │   ├── data/           # 数据实现 (DTO & Repository Impl)
│   │   │   ├── pages/          # UI 页面
│   │   │   └── widgets/        # 模块特有组件
│   │   ├── contact/            # 联系人与好友关系
│   │   ├── group/              # 群组管理
│   │   ├── call/               # RTC 音视频通话
│   │   ├── moment/             # 社交圈/朋友圈
│   │   └── user/               # 个人设置与资料
│   ├── shared/                 # 跨模块共享
│   │   ├── widgets/            # 公共原子组件、骨架屏
│   │   ├── utils/              # 编解码、文件处理、日期工具
│   │   ├── extensions/         # Dart/Flutter 语法扩展
│   │   └── l10n/               # 多语言支持 (S.of(context))
│   └── di/                     # 依赖注入 (GetIt)
├── assets/                     # 静态资源 (Images, Fonts, Lottie)
├── test/                       # 单元与 UI 测试
└── pubspec.yaml                # 依赖管理

# 重点业务流设计

## 1. 发送消息同步 (响应式 + 离线支持)
### 步骤 1：UI 触发与乐观更新
- **操作**：用户点击发送。`ChatBloc` 调用 `SendMessageUseCase`。
- **UI**：立即向 Isar 写入一条 `sendStatus = sending` 的消息。UI 通过 `watch` 机制感知变化，列表立即显示消息及其"发送中"旋转图标（乐观更新）。
### 步骤 2：Repository 异步发送
- **操作**：`ChatRepository` 将消息转为 DTO 经 `WsClient` 发送。
- **ACK 机制**：若发送成功，服务器返回 ACK (包含真正的 server_msg_id 和 seq)。
### 步骤 3：本地数据库确认
- **操作**：`WsMessageHandler` 收到 ACK，根据 client_msg_id 更新 Isar 中的消息状态为 `sent`，并补充 server_msg_id。
- **异常处理**：若超时未收到 ACK，状态自动转为 `failed`。Repository 层的 `RetryManager` 可执行指数退避重试。
### 步骤 4：UI 自动响应
- **由于 UI 订阅了 Isar Stream**，数据库状态一变，UI 自动去除旋转图标，整个过程 Bloc 无需手动拉取。

## 2. 启动增量同步 (高可用设计)
### 步骤 1：连接与握手
- **操作**：`WsClient` 连接成功后，发送 `Auth` 握手。
### 步骤 2：状态判定
- **操作**：`SyncManager` 检查本地 `last_sync_version/seq`。
- **进入同步模式**：设置 `isSyncing = true`。此时所有新到达的 WS 实时消息进入 `MessageQueue` 暂存，不更新数据库，防止乱序。
### 步骤 3：增量拉取 (Incremental Sync)
- **操作**：根据各模块记录的版本号，调用 `sync_api(since_version)`。
- **并发请求**：并发拉取【用户资料/好友/群组列表】更新。
### 4. 存入 DB 与队列合并
- **操作**：将拉取回来的差异数据批量写入 Isar。
- **操作**：同步完成后，将 `MessageQueue` 中的暂存消息依次应用到数据库（按 Seq 排序）。
### 步骤 5：状态切换
- **操作**：设置 `isSyncing = false`。
- **UI 处理**：全局同步状态栏从"收取中..."变为"听候指令"。

## 3. 消息可靠性保证 (商业化标准)
- **序列连续性检查**：每条消息自带递增的 `seq`。若某次接收发现 `current_seq > last_seq + 1`，说明有掉包，`SyncManager` 自动触发补洞逻辑（拉取缺失区间）。
- **多端已读同步**：收到已读回执 WS 时，同步更新本地数据库 `read_status`，UI 自动变灰/消失已读数。
- **离线队列**：断网期间的操作（如已读、删除）记录在 `core/sync/offline_tasks` 表中，重连后自动重试。