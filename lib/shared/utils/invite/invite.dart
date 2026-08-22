/// 邀请链接解析（对齐 PC / 服务端 inviteUrl）
///
/// 正式链接形如：
/// - `{Domain}/api/circle/v1/circle/invite_code?code=xxx`
/// - `{Domain}/api/group/v1/invite_code?code=xxx`

enum InviteKind { circle, group }

class InviteRef {
  final InviteKind kind;
  final String code;

  const InviteRef({required this.kind, required this.code});
}

/// 从邀请 URL 中解析短码
String? parseInviteCode(String raw) {
  return parseInviteRef(raw)?.code;
}

InviteRef? parseInviteRef(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return null;

  final uri = Uri.tryParse(value);
  if (uri != null) {
    // beaver://invite/circle/{code} | beaver://invite/group/{code}
    if (uri.scheme == 'beaver' && uri.host == 'invite') {
      final parts = uri.pathSegments.where((e) => e.isNotEmpty).toList();
      if (parts.length >= 2) {
        if (parts[0] == 'circle' && parts[1].isNotEmpty) {
          return InviteRef(kind: InviteKind.circle, code: parts[1]);
        }
        if (parts[0] == 'group' && parts[1].isNotEmpty) {
          return InviteRef(kind: InviteKind.group, code: parts[1]);
        }
      }
    }

    final code = uri.queryParameters['code'];
    if (code != null && code.isNotEmpty) {
      final path = uri.path.toLowerCase();
      if (path.contains('/circle/') && path.contains('invite_code')) {
        return InviteRef(kind: InviteKind.circle, code: code);
      }
      if ((path.contains('/group/') && path.contains('invite_code')) ||
          RegExp(r'/api/group/v1/invite_code', caseSensitive: false)
              .hasMatch(path)) {
        return InviteRef(kind: InviteKind.group, code: code);
      }
      if (path.contains('invite_code')) {
        // 兜底：按路径片段判断
        if (path.contains('circle')) {
          return InviteRef(kind: InviteKind.circle, code: code);
        }
        if (path.contains('group')) {
          return InviteRef(kind: InviteKind.group, code: code);
        }
      }
    }
  }

  final circle = RegExp(
    r'/api/circle/v1/circle/invite_code\?[^#]*code=([^&#]+)',
    caseSensitive: false,
  ).firstMatch(value);
  if (circle != null) {
    return InviteRef(
      kind: InviteKind.circle,
      code: Uri.decodeComponent(circle.group(1)!),
    );
  }

  final group = RegExp(
    r'/api/group/v1/invite_code\?[^#]*code=([^&#]+)',
    caseSensitive: false,
  ).firstMatch(value);
  if (group != null) {
    return InviteRef(
      kind: InviteKind.group,
      code: Uri.decodeComponent(group.group(1)!),
    );
  }

  return null;
}

bool isCircleInviteUrl(String raw) =>
    parseInviteRef(raw)?.kind == InviteKind.circle;

bool isGroupInviteUrl(String raw) =>
    parseInviteRef(raw)?.kind == InviteKind.group;
