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

import 'dart:convert';
import 'dart:math';

import 'package:beaver/features/ai/types/chat.dart';

class LgPayload {
  final String name;
  final String content;
  final String dataJson;

  const LgPayload({this.name = '', this.content = '', this.dataJson = ''});
}

const _toolLabels = <String, String>{
  'read_file': '读取文件',
  'write_file': '写入文件',
  'str_replace': '修改文件',
  'bash': '执行命令',
  'grep': '搜索',
  'glob': '匹配文件',
  'ls': '列出目录',
  'task': '子任务',
  'invoke_cloud_tool': '调用云端工具',
};

String bareToolName(String name) {
  final idx = name.lastIndexOf('__');
  if (idx < 0) return name;
  return name.substring(idx + 2);
}

String _clip(String text, [int max = 1200]) {
  if (text.length <= max) return text;
  return '${text.substring(0, max)}\n…';
}

Map<String, dynamic>? _asRecord(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

String _textOf(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  try {
    return jsonEncode(value);
  } catch (_) {
    return '';
  }
}

Map<String, dynamic>? _argsOf(dynamic input) {
  if (input is String) {
    final text = input.trim();
    if (!text.startsWith('{') && !text.startsWith('[')) return null;
    try {
      return _argsOf(jsonDecode(text));
    } catch (_) {
      return null;
    }
  }
  final record = _asRecord(input);
  if (record == null) return null;
  for (final key in ['input', 'args', 'arguments']) {
    final nested = record[key];
    if (nested == null || identical(nested, input)) continue;
    final parsed = _argsOf(nested);
    if (parsed != null &&
        (parsed['path'] != null ||
            parsed['file_path'] != null ||
            parsed['filePath'] != null ||
            parsed['command'] != null ||
            parsed['content'] != null)) {
      return parsed;
    }
  }
  return record;
}

String _pathOf(dynamic input) {
  final record = _argsOf(input);
  if (record == null) return '';
  final raw = record['path'] ?? record['file_path'] ?? record['filePath'] ?? '';
  return raw is String ? raw : '';
}

String _inputTextOf(dynamic input) {
  final record = _argsOf(input);
  if (record == null) return _clip(_textOf(input));
  final command = record['command'];
  if (command is String && command.isNotEmpty) return _clip(command);
  final path = _pathOf(record);
  final pattern = record['pattern'];
  final patternText = pattern is String ? pattern : '';
  final parts = [path, patternText].where((item) => item.isNotEmpty).toList();
  if (parts.isNotEmpty) return parts.join(' · ');
  return _clip(_textOf(record));
}

String _baseName(String path) {
  final parts = path.replaceAll('\\', '/').split('/').where((item) => item.isNotEmpty).toList();
  if (parts.isEmpty) return path.isNotEmpty ? path : '文件';
  return parts.last;
}

String _newId(String prefix) {
  final rand = Random().nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
  return '${prefix}_${DateTime.now().millisecondsSinceEpoch}_$rand';
}

AiArtifact? _artifactFromWrite(AiToolStep step, dynamic input) {
  if (bareToolName(step.name) != 'write_file' || step.status != AiToolStatus.done) return null;
  final record = _argsOf(input);
  final content = record?['content'];
  if (content is! String || content.trim().isEmpty) return null;
  final path = step.path.isNotEmpty ? step.path : _pathOf(input);
  final lower = path.toLowerCase();
  final isHtml = lower.endsWith('.html') ||
      lower.endsWith('.htm') ||
      RegExp(r'^\s*<!doctype html', caseSensitive: false).hasMatch(content) ||
      RegExp(r'^\s*<html', caseSensitive: false).hasMatch(content);
  return AiArtifact(
    id: _newId('art'),
    name: _baseName(path),
    type: isHtml ? AiArtifactType.html : AiArtifactType.md,
    content: content,
    timestamp: DateTime.now().millisecondsSinceEpoch,
    path: path,
  );
}

class ApplyLgResult {
  final List<AiToolStep> tools;
  final AiArtifact? artifact;

  const ApplyLgResult({required this.tools, this.artifact});
}

ApplyLgResult applyLgEvent(List<AiToolStep> tools, LgPayload payload) {
  final raw = payload.name;
  final kind = raw.split(':').first;
  if (kind != 'on_tool_start' && kind != 'on_tool_end' && kind != 'on_tool_error') {
    return ApplyLgResult(tools: tools);
  }

  final toolName = bareToolName((payload.content.isNotEmpty ? payload.content : raw.split(':').length > 1 ? raw.split(':')[1] : 'tool').trim());
  Map<String, dynamic> data = {};
  if (payload.dataJson.isNotEmpty) {
    try {
      final parsed = jsonDecode(payload.dataJson);
      data = _asRecord(parsed) ?? {};
    } catch (_) {
      data = {};
    }
  }

  if (kind == 'on_tool_start') {
    final step = AiToolStep(
      id: _newId('tool'),
      name: toolName,
      label: _toolLabels[toolName] ?? toolName,
      status: AiToolStatus.running,
      inputText: _inputTextOf(data['input']),
      path: _pathOf(data['input']),
      rawInput: _textOf(data['input']),
    );
    return ApplyLgResult(tools: [...tools, step]);
  }

  var realIndex = -1;
  for (var i = tools.length - 1; i >= 0; i--) {
    if (tools[i].name == toolName && tools[i].status == AiToolStatus.running) {
      realIndex = i;
      break;
    }
  }
  if (realIndex < 0) return ApplyLgResult(tools: tools);

  final prev = tools[realIndex];
  final next = prev.copyWith(
    status: kind == 'on_tool_error' ? AiToolStatus.error : AiToolStatus.done,
    path: prev.path.isNotEmpty ? prev.path : _pathOf(data['input']),
    inputText: prev.inputText.isNotEmpty ? prev.inputText : _inputTextOf(data['input']),
    outputText: _clip(_textOf(data['output'])),
    rawInput: data['input'] != null ? _textOf(data['input']) : prev.rawInput,
  );
  final copied = [...tools];
  copied[realIndex] = next;

  dynamic input = data['input'];
  if (input == null && next.rawInput.isNotEmpty) {
    try {
      input = jsonDecode(next.rawInput);
    } catch (_) {
      input = null;
    }
  }
  return ApplyLgResult(tools: copied, artifact: _artifactFromWrite(next, input));
}

List<AiToolStep> collectTasks(List<AiMessageView> messages) {
  final list = <AiToolStep>[];
  for (final message in messages) {
    if (message.tools.isNotEmpty) list.addAll(message.tools);
  }
  return list;
}

class AiFileCard {
  final String path;
  final String name;
  final String label;

  const AiFileCard({required this.path, required this.name, required this.label});
}

List<AiFileCard> collectFileCards(List<AiToolStep> tools) {
  const fileTools = {'write_file', 'str_replace'};
  final seen = <String>{};
  final files = <AiFileCard>[];
  for (final step in tools) {
    final bare = bareToolName(step.name);
    if (!fileTools.contains(bare)) continue;
    if (step.path.isEmpty || seen.contains(step.path)) continue;
    seen.add(step.path);
    files.add(AiFileCard(
      path: step.path,
      name: _baseName(step.path),
      label: step.label,
    ));
  }
  return files;
}

/// 供 UI / store 共用的消息视图字段。
class AiMessageView {
  final String id;
  final String role;
  final String content;
  final bool streaming;
  final int timestamp;
  final List<AiToolStep> tools;

  const AiMessageView({
    required this.id,
    required this.role,
    this.content = '',
    this.streaming = false,
    this.timestamp = 0,
    this.tools = const [],
  });

  AiMessageView copyWith({
    String? content,
    bool? streaming,
    List<AiToolStep>? tools,
  }) {
    return AiMessageView(
      id: id,
      role: role,
      content: content ?? this.content,
      streaming: streaming ?? this.streaming,
      timestamp: timestamp,
      tools: tools ?? this.tools,
    );
  }
}
