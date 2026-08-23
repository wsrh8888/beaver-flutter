/**
 * Copyright (c) 2024-2026 Beaver IM Team
 * SPDX-License-Identifier: MIT
 * Project: beaver-flutter
 * https://github.com/wsrh8888/beaver-flutter
 *
 * 中文：
 * 本文件为海狸 IM（Beaver IM）开源项目源代码。
 * 版权所有 © 2024-2026 Beaver IM Team，基于 MIT 协议授权。
 * 禁止删除、篡改或替换本文件头部版权与许可声明。
 * 使用与商业授权说明：https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * English:
 * This file is part of the Beaver IM open-source project.
 * Copyright (c) 2024-2026 Beaver IM Team. Licensed under the MIT License.
 * Do not remove, alter, or replace this copyright and license header.
 * Usage & commercial licensing: https://wsrh8888.github.io/beaver-docs/community/license.html
 *
 * beaver-flutter-header-v1
 */

class CallPageRepository {
  Future<void> startCall(String conversationId) async {
    // 模拟开始通话
    await Future.delayed(const Duration(seconds: 1));
  }
  
  Future<void> endCall(String conversationId) async {
    // 模拟结束通话
    await Future.delayed(const Duration(seconds: 1));
  }
  
  Future<void> toggleMute(bool isMuted) async {
    // 模拟切换静音
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  Future<void> toggleCamera(bool isCameraOn) async {
    // 模拟切换摄像头
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  Future<void> toggleSpeaker(bool isSpeakerOn) async {
    // 模拟切换扬声器
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
