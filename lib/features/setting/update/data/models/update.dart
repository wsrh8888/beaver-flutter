class VersionInfo {
  final String version;
  final String size;
  final String releaseNotes;
  final String downloadUrl;
  final bool isForce;

  const VersionInfo({
    required this.version,
    required this.size,
    required this.releaseNotes,
    required this.downloadUrl,
    this.isForce = false,
  });

  VersionInfo copyWith({
    String? version,
    String? size,
    String? releaseNotes,
    String? downloadUrl,
    bool? isForce,
  }) {
    return VersionInfo(
      version: version ?? this.version,
      size: size ?? this.size,
      releaseNotes: releaseNotes ?? this.releaseNotes,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      isForce: isForce ?? this.isForce,
    );
  }
}

class UpdateInfo {
  final bool hasUpdate;
  final VersionInfo? latestVersion;
  final bool isChecking;
  final bool isDownloading;
  final int downloadProgress;
  final DateTime? lastCheckTime;

  const UpdateInfo({
    required this.hasUpdate,
    this.latestVersion,
    required this.isChecking,
    required this.isDownloading,
    required this.downloadProgress,
    this.lastCheckTime,
  });

  UpdateInfo copyWith({
    bool? hasUpdate,
    VersionInfo? latestVersion,
    bool? isChecking,
    bool? isDownloading,
    int? downloadProgress,
    DateTime? lastCheckTime,
  }) {
    return UpdateInfo(
      hasUpdate: hasUpdate ?? this.hasUpdate,
      latestVersion: latestVersion ?? this.latestVersion,
      isChecking: isChecking ?? this.isChecking,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      lastCheckTime: lastCheckTime ?? this.lastCheckTime,
    );
  }
}
