beaver-flutter/
├── android/                    # Android 平台特定代码
├── ios/                        # iOS 平台特定代码
├── lib/                        # Flutter 核心代码
│   ├── main.dart               # 应用入口文件，初始化应用
│   ├── app/                    # 应用入口组件
│   │   └── app.dart            # 根组件，负责全局 Provider 初始化和应用启动
│   ├── core/                   # 核心基础设施，不随业务改变的底层能力
│   │   ├── network/            # 网络相关服务
│   │   │   ├── api/            # API 服务，处理 HTTP 请求
│   │   │   │   ├── api_client.dart      # API 客户端基础配置
│   │   │   │   ├── auth_api.dart        # 认证相关 API
│   │   │   │   ├── chat_api.dart        # 聊天相关 API
│   │   │   │   ├── contact_api.dart     # 联系人相关 API
│   │   │   │   ├── group_api.dart       # 群组相关 API
│   │   │   │   └── user_api.dart        # 用户相关 API
│   │   │   └── websocket/      # WebSocket 服务，处理实时通信
│   │   │       ├── ws_client.dart        # WebSocket 客户端，建立和管理连接
│   │   │       ├── ws_manager.dart       # WebSocket 管理器，处理重连和心跳
│   │   │       └── ws_message_handler.dart # WebSocket 消息处理器
│   │   ├── database/           # 数据库服务，处理本地存储
│   │   │   ├── isar_helper.dart # Isar 数据库初始化和管理
│   │   │   └── collections/    # Isar 集合定义
│   │   │       ├── chat_collection.dart     # 聊天相关集合
│   │   │       ├── contact_collection.dart  # 联系人相关集合
│   │   │       ├── group_collection.dart    # 群组相关集合
│   │   │       └── user_collection.dart     # 用户相关集合
│   │   ├── cache/              # 缓存服务
│   │   │   ├── cache_manager.dart # 缓存管理器
│   │   │   └── image_cache.dart    # 图片缓存
│   │   ├── router/             # 路由配置
│   │   │   └── app_router.dart # GoRouter 配置，定义应用路由
│   │   ├── theme/              # 主题配置
│   │   │   └── app_theme.dart  # 主题定义，包括颜色、字体等
│   │   ├── constants/          # 全局常量
│   │   │   └── app_constants.dart # 应用全局常量
│   │   └── error/              # 统一错误定义
│   │       └── error_handler.dart # 错误处理工具
│   ├── data/                   # 全局共享数据协议
│   │   ├── models/             # 全局共用 DTO（数据传输对象）
│   │   │   ├── user_dto.dart       # 用户相关 DTO
│   │   │   ├── message_dto.dart     # 消息相关 DTO
│   │   │   └── common_dto.dart      # 通用 DTO
│   │   └── protobuf/           # Protobuf 生成代码（如果使用）
│   ├── features/               # 业务模块，按功能划分
│   │   ├── auth/               # 认证模块
│   │   │   ├── bloc/           # 状态管理
│   │   │   │   ├── auth_bloc.dart     # 认证 Bloc
│   │   │   │   ├── auth_event.dart    # 认证事件
│   │   │   │   └── auth_state.dart    # 认证状态
│   │   │   ├── domain/         # 业务实体（Entity）
│   │   │   │   └── user_entity.dart   # 用户实体
│   │   │   ├── data/           # 数据层
│   │   │   │   ├── models/     # 模块特有的 DTO
│   │   │   │   │   ├── login_request.dart    # 登录请求 DTO
│   │   │   │   │   └── register_request.dart # 注册请求 DTO
│   │   │   │   └── repositories/ # 数据仓库实现
│   │   │   │       ├── auth_repository.dart       # 认证仓库接口
│   │   │   │       └── auth_repository_impl.dart  # 认证仓库实现
│   │   │   ├── pages/          # 页面（替代 screens，更符合 Flutter 命名）
│   │   │   │   ├── guide_page.dart           # 引导页
│   │   │   │   ├── login_page.dart           # 登录页
│   │   │   │   ├── register_page.dart        # 注册页
│   │   │   │   ├── forget_password_page.dart # 忘记密码页
│   │   │   │   ├── about_page.dart           # 关于页
│   │   │   │   ├── agreement_page.dart       # 协议页
│   │   │   │   └── privacy_page.dart         # 隐私页
│   │   │   └── widgets/        # 组件
│   │   ├── chat/               # 聊天模块
│   │   │   ├── bloc/
│   │   │   │   ├── chat_bloc.dart     # 聊天 Bloc
│   │   │   │   ├── chat_event.dart    # 聊天事件
│   │   │   │   └── chat_state.dart    # 聊天状态
│   │   │   ├── domain/         # 业务实体
│   │   │   │   ├── message_entity.dart       # 消息实体
│   │   │   │   └── conversation_entity.dart  # 会话实体
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── message_dto.dart       # 消息 DTO
│   │   │   │   │   └── conversation_dto.dart  # 会话 DTO
│   │   │   │   └── repositories/
│   │   │   │       ├── chat_repository.dart       # 聊天仓库接口
│   │   │   │       └── chat_repository_impl.dart  # 聊天仓库实现
│   │   │   ├── pages/
│   │   │   │   ├── chat_list_page.dart    # 消息列表页（首页）
│   │   │   │   ├── chat_detail_page.dart  # 聊天详情页
│   │   │   │   ├── search_friend_page.dart # 搜索好友页
│   │   │   │   └── detail_page.dart       # 详情页
│   │   │   └── widgets/
│   │   │       ├── message_item.dart  # 消息项组件
│   │   │       └── message_input.dart # 消息输入组件
│   │   ├── contact/            # 联系人模块
│   │   │   ├── bloc/
│   │   │   │   ├── contact_bloc.dart     # 联系人 Bloc
│   │   │   │   ├── contact_event.dart    # 联系人事件
│   │   │   │   └── contact_state.dart    # 联系人状态
│   │   │   ├── domain/
│   │   │   │   └── contact_entity.dart   # 联系人实体
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── contact_dto.dart  # 联系人 DTO
│   │   │   │   └── repositories/
│   │   │   │       ├── contact_repository.dart       # 联系人仓库接口
│   │   │   │       └── contact_repository_impl.dart  # 联系人仓库实现
│   │   │   ├── pages/
│   │   │   │   ├── friend_list_page.dart   # 好友列表页
│   │   │   │   └── new_friends_page.dart  # 新好友页
│   │   │   └── widgets/
│   │   │       └── contact_item.dart  # 联系人项组件
│   │   ├── group/              # 群组模块
│   │   │   ├── bloc/
│   │   │   │   ├── group_bloc.dart     # 群组 Bloc
│   │   │   │   ├── group_event.dart    # 群组事件
│   │   │   │   └── group_state.dart    # 群组状态
│   │   │   ├── domain/
│   │   │   │   ├── group_entity.dart        # 群组实体
│   │   │   │   └── group_member_entity.dart # 群成员实体
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── group_dto.dart        # 群组 DTO
│   │   │   │   │   └── group_member_dto.dart # 群成员 DTO
│   │   │   │   └── repositories/
│   │   │   │       ├── group_repository.dart       # 群组仓库接口
│   │   │   │       └── group_repository_impl.dart  # 群组仓库实现
│   │   │   ├── pages/
│   │   │   │   ├── group_list_page.dart     # 群组列表页
│   │   │   │   ├── group_member_page.dart   # 群成员页
│   │   │   │   ├── group_config_page.dart   # 群设置页
│   │   │   │   └── create_group_page.dart  # 创建群组页
│   │   │   └── widgets/
│   │   ├── call/               # 音视频通话模块
│   │   │   ├── bloc/
│   │   │   │   ├── call_bloc.dart     # 通话 Bloc
│   │   │   │   ├── call_event.dart    # 通话事件
│   │   │   │   └── call_state.dart    # 通话状态
│   │   │   ├── domain/
│   │   │   │   └── call_entity.dart   # 通话实体
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── call_dto.dart  # 通话 DTO
│   │   │   │   └── repositories/
│   │   │   │       ├── call_repository.dart       # 通话仓库接口
│   │   │   │       └── call_repository_impl.dart  # 通话仓库实现
│   │   │   ├── pages/
│   │   │   │   ├── call_incoming_page.dart # 来电页面
│   │   │   │   └── call_page.dart          # 通话页面
│   │   │   └── widgets/
│   │   │       └── call_controls.dart  # 通话控制组件
│   │   ├── moment/             # 朋友圈模块
│   │   │   ├── bloc/
│   │   │   │   ├── moment_bloc.dart     # 朋友圈 Bloc
│   │   │   │   ├── moment_event.dart    # 朋友圈事件
│   │   │   │   └── moment_state.dart    # 朋友圈状态
│   │   │   ├── domain/
│   │   │   │   └── moment_entity.dart   # 朋友圈实体
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── moment_dto.dart  # 朋友圈 DTO
│   │   │   │   └── repositories/
│   │   │   │       ├── moment_repository.dart       # 朋友圈仓库接口
│   │   │   │       └── moment_repository_impl.dart  # 朋友圈仓库实现
│   │   │   ├── pages/
│   │   │   │   ├── moment_page.dart       # 朋友圈页
│   │   │   │   └── post_moment_page.dart  # 发布朋友圈页
│   │   │   └── widgets/
│   │   └── user/               # 个人中心模块
│   │       ├── bloc/
│   │       │   ├── user_bloc.dart     # 用户 Bloc
│   │       │   ├── user_event.dart    # 用户事件
│   │       │   └── user_state.dart    # 用户状态
│   │       ├── domain/
│   │       │   └── user_profile_entity.dart # 用户资料实体
│   │       ├── data/
│   │       │   ├── models/
│   │       │   │   └── user_profile_dto.dart # 用户资料 DTO
│   │       │   └── repositories/
│   │       │       ├── user_repository.dart       # 用户仓库接口
│   │       │       └── user_repository_impl.dart  # 用户仓库实现
│   │       ├── pages/
│   │       │   ├── mine_page.dart          # 我的页面
│   │       │   ├── profile_page.dart       # 个人资料页
│   │       │   ├── qrcode_page.dart        # 二维码页
│   │       │   ├── setting_page.dart       # 设置页
│   │       │   ├── theme_page.dart         # 主题页
│   │       │   ├── user_config_page.dart   # 用户设置页
│   │       │   ├── feedback_page.dart      # 反馈页
│   │       │   ├── update_page.dart        # 检查更新页
│   │       │   └── disclaimer_page.dart    # 项目声明页
│   │       └── widgets/
│   ├── shared/                 # 共享资源，供多个模块使用
│   │   ├── widgets/            # 公共组件
│   │   │   ├── common/         # 通用组件
│   │   │   │   ├── app_bar.dart       # 自定义应用栏
│   │   │   │   ├── loading.dart        # 加载状态组件
│   │   │   │   └── skeletons/         # 骨架屏组件
│   │   │   │       ├── skeleton_chat.dart     # 聊天页面骨架屏
│   │   │   │       ├── skeleton_contact.dart  # 联系人页面骨架屏
│   │   │   │       ├── skeleton_moment.dart   # 朋友圈页面骨架屏
│   │   │   │       └── skeleton_generic.dart  # 通用骨架屏
│   │   │   ├── message/        # 消息相关组件
│   │   │   ├── contact/        # 联系人相关组件
│   │   │   └── call/           # 通话相关组件
│   │   ├── utils/              # 工具类
│   │   │   ├── date_util.dart       # 日期处理工具
│   │   │   ├── network_util.dart    # 网络工具
│   │   │   ├── storage_util.dart    # 存储工具
│   │   │   └── cache_util.dart      # 缓存工具
│   │   ├── extensions/         # 扩展方法
│   │   │   ├── string_extensions.dart # 字符串扩展
│   │   │   └── date_extensions.dart  # 日期扩展
│   │   └── l10n/               # 国际化
│   │       ├── app_localizations.dart    # 本地化基础类
│   │       └── app_localizations_en.dart # 英文本地化
│   └── di/                     # 依赖注入
│       └── injection.dart      # GetIt 配置，管理服务和仓库的依赖
├── assets/                     # 静态资源
│   ├── images/                 # 图片资源
│   │   ├── logo/               # 应用 logo
│   │   └── icons/              # 图标资源
│   └── fonts/                  # 字体资源
├── test/                       # 测试代码
│   ├── unit/                   # 单元测试
│   └── widget/                 # 组件测试
├── pubspec.yaml                # 依赖配置文件
└── README.md                   # 项目说明文件





# 发送消息同步
### 步骤 1：用户在 UI 层触发发送
- 文件 ： lib/features/chat/pages/chat_detail_page.dart
- 操作 ：用户在聊天详情页输入消息并点击发送按钮
### 步骤 2：状态管理处理
- 文件 ： lib/features/chat/bloc/chat_bloc.dart
- 操作 ： ChatBloc 接收 SendMessage 事件，更新状态为 MessageSending ，UI 显示"发送中"状态
### 步骤 3：数据仓库处理
- 文件 ： lib/features/chat/data/repositories/chat_repository_impl.dart
- 操作 ： ChatRepository 调用 sendMessage 方法，将消息转换为 DTO
### 步骤 4：WebSocket 发送
- 文件 ： lib/core/network/websocket/ws_client.dart
- 操作 ： WsClient 将消息封装为 WebSocket 格式并发送到服务器
## 2. 消息确认与同步流程
### 步骤 5：服务器处理消息
- 操作 ：服务器接收并处理消息，然后向 Flutter 客户端发送通知消息，告知消息已成功处理
### 步骤 6：WebSocket 接收通知
- 文件 ： lib/core/network/websocket/ws_client.dart
- 操作 ： WsClient 接收服务器返回的通知消息
### 步骤 7：消息处理器处理
- 文件 ： lib/core/network/websocket/ws_message_handler.dart
- 操作 ： WsMessageHandler 解析接收到的通知消息，识别为消息处理成功的通知
### 步骤 8：触发本地同步逻辑
- 文件 ： lib/core/network/websocket/ws_message_handler.dart
- 操作 ：调用数据同步服务，开始执行本地同步逻辑
### 步骤 9：数据同步处理
- 文件 ： lib/core/network/websocket/ws_message_handler.dart
- 操作 ：将服务器返回的消息数据同步到本地数据库
### 步骤 10：数据库存储
- 文件 ： lib/core/database/isar_helper.dart
- 操作 ： IsarHelper 将消息保存到本地 chat_collection ，更新消息状态为"已发送"
### 步骤 11：同步完成通知
- 文件 ： lib/core/network/websocket/ws_message_handler.dart
- 操作 ：数据同步完成后，通知 ChatBloc 消息发送成功
### 步骤 12：状态更新
- 文件 ： lib/features/chat/bloc/chat_bloc.dart
- 操作 ： ChatBloc 接收到同步完成的通知，更新状态为 MessageSent
### 步骤 13：UI 层更新
- 文件 ： lib/features/chat/pages/chat_detail_page.dart
- 操作 ： ChatDetailPage 监听 ChatBloc 状态变化，重新渲染消息列表，显示消息"已发送"状态


# 启动项目同步
## 1. 启动同步流程
### 步骤 1：应用启动
- 文件 ： lib/main.dart
- 操作 ：应用初始化，启动 Flutter 应用
### 步骤 2：依赖注入初始化
- 文件 ： lib/di/injection.dart
- 操作 ：初始化 GetIt，注册所有服务和仓库
### 步骤 3：WebSocket 连接
- 文件 ： lib/core/network/websocket/ws_client.dart
- 操作 ： WsClient 建立 WebSocket 连接，携带用户 Token
### 步骤 4：连接成功触发同步
- 文件 ： lib/core/network/websocket/ws_client.dart
- 操作 ：WebSocket 连接成功后，触发数据同步
### 步骤 5：数据同步管理器启动
- 文件 ： lib/core/network/websocket/ws_message_handler.dart
- 操作 ： WsMessageHandler 调用数据同步服务，开始全量同步
### 步骤 6：各模块数据同步
- 文件 ： lib/core/network/websocket/ws_message_handler.dart
- 操作 ：按顺序执行各模块同步
  - 用户数据同步
  - 聊天数据同步
  - 联系人数据同步
  - 群组数据同步
  - 表情数据同步
  - 通知数据同步
### 步骤 7：数据存储到本地数据库
- 文件 ： lib/core/database/isar_helper.dart
- 操作 ：将同步的数据写入本地 Isar 数据库
### 步骤 8：同步完成通知
- 文件 ： lib/core/network/websocket/ws_message_handler.dart
- 操作 ：数据同步完成后，通知各业务模块
### 步骤 9：各模块重新拉取数据
- 文件 ：
  - lib/features/chat/bloc/chat_bloc.dart
  - lib/features/contact/bloc/contact_bloc.dart
  - lib/features/group/bloc/group_bloc.dart
  - lib/features/user/bloc/user_bloc.dart
- 操作 ：各模块 Bloc 接收到同步完成通知，从本地数据库重新拉取数据
### 步骤 10：UI 层更新
- 文件 ：
  - lib/features/chat/pages/chat_list_page.dart
  - lib/features/contact/pages/friend_list_page.dart
  - lib/features/group/pages/group_list_page.dart
  - lib/features/user/pages/mine_page.dart
- 操作 ：各页面监听 Bloc 状态变化，重新渲染 UI，显示同步后的数据