// Business层统一入口 (对标 PC business/index.ts)

import 'package:beaver/di/injection.dart';
import 'chat/conversation.dart';
import 'chat/message.dart';
import 'chat/user_conversation.dart';
import 'friend/friend.dart';
import 'friend/friend_verify.dart';
import 'group/group.dart';
import 'user/user.dart';
import 'notification/inbox.dart';
import 'notification/read_cursor.dart';
import 'notification/event.dart';
import 'media/media.dart';

export 'chat/conversation.dart';
export 'chat/message.dart';
export 'chat/user_conversation.dart';
export 'friend/friend.dart';
export 'friend/friend_verify.dart';
export 'group/group.dart';
export 'user/user.dart';
export 'notification/inbox.dart';
export 'notification/read_cursor.dart';
export 'notification/event.dart';
export 'media/media.dart';

// Chat模块
final conversationBusiness = getIt<ConversationBusiness>();
final messageBusiness = getIt<MessageBusiness>();
final userConversationBusiness = getIt<UserConversationBusiness>();

// Friend模块
final friendBusiness = getIt<FriendBusiness>();
final friendVerifyBusiness = getIt<FriendVerifyBusiness>();

// Group模块
final groupBusiness = getIt<GroupBusiness>();

// User模块
final userBusiness = getIt<UserBusiness>();

// Notification模块
final notificationInboxBusiness = getIt<NotificationInboxBusiness>();
final notificationReadCursorBusiness = getIt<NotificationReadCursorBusiness>();
final notificationEventBusiness = getIt<NotificationEventBusiness>();

// Media模块
final mediaBusiness = getIt<MediaBusiness>();
