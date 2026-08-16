class IWorkbenchEntryConfig {
  /// 0 路由 key，1 H5 地址
  final int type;
  final String pc;
  final String mobile;

  const IWorkbenchEntryConfig({
    this.type = 1,
    this.pc = '',
    this.mobile = '',
  });

  factory IWorkbenchEntryConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const IWorkbenchEntryConfig();
    }
    return IWorkbenchEntryConfig(
      type: json['type'] ?? 1,
      pc: json['pc'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}

class IWorkbenchAppItem {
  final String workbenchAppId;
  final String name;
  final String description;
  final String icon;
  /// 0 内部，1 第三方 H5
  final int appType;
  /// 0 全部，1 仅 PC，2 仅移动
  final int clientScope;
  final IWorkbenchEntryConfig entryConfig;
  final int category;
  final int sort;
  /// 打开方式：0 内嵌 WebView，1 系统浏览器
  final int openMode;

  const IWorkbenchAppItem({
    required this.workbenchAppId,
    required this.name,
    required this.description,
    required this.icon,
    required this.appType,
    required this.clientScope,
    required this.entryConfig,
    required this.category,
    required this.sort,
    this.openMode = 0,
  });

  factory IWorkbenchAppItem.fromJson(Map<String, dynamic> json) {
    return IWorkbenchAppItem(
      workbenchAppId: json['workbenchAppId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      appType: json['appType'] ?? 1,
      clientScope: json['clientScope'] ?? 0,
      entryConfig: IWorkbenchEntryConfig.fromJson(
        json['entryConfig'] as Map<String, dynamic>?,
      ),
      category: json['category'] ?? 0,
      sort: json['sort'] ?? 0,
      openMode: json['openMode'] ?? 0,
    );
  }

  /// 解析移动端入口：优先 mobile，回退 pc
  String resolveEntry() {
    final primary = entryConfig.mobile.trim();
    if (primary.isNotEmpty) return primary;
    return entryConfig.pc.trim();
  }
}

class IWorkbenchAppGroup {
  final int category;
  final String categoryName;
  final List<IWorkbenchAppItem> list;

  const IWorkbenchAppGroup({
    required this.category,
    required this.categoryName,
    required this.list,
  });

  factory IWorkbenchAppGroup.fromJson(Map<String, dynamic> json) {
    final rawList = json['list'] as List<dynamic>? ?? [];
    return IWorkbenchAppGroup(
      category: json['category'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      list: rawList
          .map((item) => IWorkbenchAppItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class IListWorkbenchAppsReq {
  /// 1 PC，2 移动
  final int? clientScope;

  const IListWorkbenchAppsReq({this.clientScope});

  Map<String, dynamic> toJson() => {
        if (clientScope != null) 'clientScope': clientScope,
      };
}

class IListWorkbenchAppsRes {
  final List<IWorkbenchAppGroup> groups;

  const IListWorkbenchAppsRes({required this.groups});

  factory IListWorkbenchAppsRes.fromJson(Map<String, dynamic> json) {
    final rawGroups = json['groups'] as List<dynamic>? ?? [];
    return IListWorkbenchAppsRes(
      groups: rawGroups
          .map((item) => IWorkbenchAppGroup.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
