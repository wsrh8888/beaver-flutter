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

/// 与桌面 AI 会话模型对齐（WorkBuddy / agent_electron）。
const kAiDraftThreadId = 'draft';

enum AiToolStatus { running, done, error }

class AiToolStep {
  final String id;
  final String name;
  final String label;
  final AiToolStatus status;
  final String inputText;
  final String outputText;
  final String path;
  final String rawInput;

  const AiToolStep({
    required this.id,
    required this.name,
    required this.label,
    required this.status,
    this.inputText = '',
    this.outputText = '',
    this.path = '',
    this.rawInput = '',
  });

  AiToolStep copyWith({
    AiToolStatus? status,
    String? inputText,
    String? outputText,
    String? path,
    String? rawInput,
  }) {
    return AiToolStep(
      id: id,
      name: name,
      label: label,
      status: status ?? this.status,
      inputText: inputText ?? this.inputText,
      outputText: outputText ?? this.outputText,
      path: path ?? this.path,
      rawInput: rawInput ?? this.rawInput,
    );
  }
}

enum AiArtifactType { md, html }

class AiArtifact {
  final String id;
  final String name;
  final AiArtifactType type;
  final String content;
  final int timestamp;
  final String path;

  const AiArtifact({
    required this.id,
    required this.name,
    required this.type,
    required this.content,
    required this.timestamp,
    this.path = '',
  });
}
