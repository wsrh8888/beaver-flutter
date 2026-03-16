class VersionInfo {
  final String version;
  final String size;
  final String releaseNotes;
  final String downloadUrl;

  const VersionInfo({
    required this.version,
    required this.size,
    required this.releaseNotes,
    required this.downloadUrl,
  });
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
}
