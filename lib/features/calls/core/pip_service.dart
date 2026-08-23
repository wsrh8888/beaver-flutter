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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PiPService {
  static final PiPService _instance = PiPService._private();
  factory PiPService() => _instance;
  
  PiPService._private();
  
  MethodChannel? _channel;
  bool _isInPiPMode = false;
  
  void initialize() {
    _channel = MethodChannel('beaver/pip');
  }
  
  Future<bool> isPiPSupported() async {
    if (_channel == null) return false;
    
    try {
      return await _channel!.invokeMethod('isPiPSupported') ?? false;
    } catch (e) {
      print('检查画中画支持失败: $e');
      return false;
    }
  }
  
  Future<void> enterPiPMode() async {
    if (_channel == null) return;
    
    try {
      await _channel!.invokeMethod('enterPiPMode');
      _isInPiPMode = true;
    } catch (e) {
      print('进入画中画模式失败: $e');
    }
  }
  
  Future<void> exitPiPMode() async {
    if (_channel == null) return;
    
    try {
      await _channel!.invokeMethod('exitPiPMode');
      _isInPiPMode = false;
    } catch (e) {
      print('退出画中画模式失败: $e');
    }
  }
  
  bool get isInPiPMode => _isInPiPMode;
  
  // 监听画中画状态变化
  void setPiPStateListener(Function(bool isInPiP) listener) {
    if (_channel == null) return;
    
    _channel!.setMethodCallHandler((call) async {
      if (call.method == 'onPiPStateChanged') {
        final isInPiP = call.arguments as bool;
        _isInPiPMode = isInPiP;
        listener(isInPiP);
      }
      return null;
    });
  }
}

// 画中画组件
class PiPWidget extends StatefulWidget {
  final Widget child;
  final double pipWidth;
  final double pipHeight;
  final bool isInPiPMode;

  const PiPWidget({
    super.key,
    required this.child,
    this.pipWidth = 200,
    this.pipHeight = 112.5, // 16:9 比例
    this.isInPiPMode = false,
  });

  @override
  State<PiPWidget> createState() => _PiPWidgetState();
}

class _PiPWidgetState extends State<PiPWidget> {
  Offset _position = const Offset(20, 20);
  bool _isDragging = false;
  Offset _dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    if (!widget.isInPiPMode) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
            onPanStart: (details) {
              _isDragging = true;
              _dragOffset = details.localPosition;
            },
            onPanUpdate: (details) {
              if (_isDragging) {
                setState(() {
                  _position = Offset(
                    details.globalPosition.dx - _dragOffset.dx,
                    details.globalPosition.dy - _dragOffset.dy,
                  );
                  
                  // 限制在屏幕内
                  final screenSize = MediaQuery.of(context).size;
                  _position = Offset(
                    _position.dx.clamp(0, screenSize.width - widget.pipWidth),
                    _position.dy.clamp(0, screenSize.height - widget.pipHeight),
                  );
                });
              }
            },
            onPanEnd: (_) {
              _isDragging = false;
            },
            child: Container(
              width: widget.pipWidth,
              height: widget.pipHeight,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
