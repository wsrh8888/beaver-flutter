class IWorkbenchAppItem {
  final String workbenchAppId;
  final String name;
  final String description;
  final String icon;
  final String entryUrl;
  final String category;
  final int sort;

  const IWorkbenchAppItem({
    required this.workbenchAppId,
    required this.name,
    required this.description,
    required this.icon,
    required this.entryUrl,
    required this.category,
    required this.sort,
  });

  factory IWorkbenchAppItem.fromJson(Map<String, dynamic> json) {
    return IWorkbenchAppItem(
      workbenchAppId: json['workbenchAppId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      entryUrl: json['entryUrl'] ?? '',
      category: json['category'] ?? '',
      sort: json['sort'] ?? 0,
    );
  }
}

class IListWorkbenchAppsReq {
  final String? category;

  const IListWorkbenchAppsReq({this.category});

  Map<String, dynamic> toJson() => {
        if (category != null) 'category': category,
      };
}

class IListWorkbenchAppsRes {
  final List<IWorkbenchAppItem> list;

  const IListWorkbenchAppsRes({required this.list});

  factory IListWorkbenchAppsRes.fromJson(Map<String, dynamic> json) {
    final rawList = json['list'] as List<dynamic>? ?? [];
    return IListWorkbenchAppsRes(
      list: rawList
          .map((item) => IWorkbenchAppItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
