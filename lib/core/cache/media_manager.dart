import 'dart:io';
import 'package:beaver/types/cache.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/shared/utils/file/cache.dart';
import 'config.dart';

/// 媒体缓存管理器 - 对标 Desktop MediaManager
class MediaManager {
  static final MediaManager _instance = MediaManager._internal();
  factory MediaManager() => _instance;
  MediaManager._internal() {
    _initDio();
  }

  String? _userId;
  String? _cacheRoot;
  final Map<String, Future<String?>> _downloadFutures = {};
  final Map<String, String> _cacheFile = {};
  bool _initialized = false;
  late Dio _dio;

  void _initDio() {
    _dio = Dio();
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
  }

  Future<void> init(String? userId) async {
    _userId = userId;
    final appDir = await getApplicationDocumentsDirectory();
    _cacheRoot = appDir.path;
    _cacheFile.clear();
    _initialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized || _cacheRoot == null) {
      await init(_userId);
    }
  }

  MediaService get _mediaService => getIt<MediaService>();

  String _resolveCacheDir(CacheType type) {
    final userId = _userId ?? 'public';
    final subPath = CachePathConfig.getRelativePath(type, userId);
    return p.join(_cacheRoot!, subPath);
  }

  String _resolveOutputPath(CacheType type, String contentMd5, String fileUrl) {
    return p.join(_resolveCacheDir(type), getCacheLocalFileName(contentMd5, fileUrl));
  }

  String _createTempPath(CacheType type) {
    return p.join(_resolveCacheDir(type), '.tmp', '${DateTime.now().millisecondsSinceEpoch}');
  }

  /// [fileUrl] 完整远程 URL（与 media.url 一致）
  Future<String?> add(CacheType type, String fileUrl) async {
    await _ensureInitialized();
    if (fileUrl.isEmpty) return null;

    if (_downloadFutures.containsKey(fileUrl)) {
      return _downloadFutures[fileUrl];
    }

    final downloadFuture = _doAdd(type, fileUrl);
    _downloadFutures[fileUrl] = downloadFuture;

    try {
      return await downloadFuture;
    } finally {
      _downloadFutures.remove(fileUrl);
    }
  }

  Future<String?> _doAdd(CacheType type, String fileUrl) async {
    try {
      final cacheInfo = await _mediaService.getMediaByUrl(fileUrl);
      if (cacheInfo != null && cacheInfo['isDeleted'] == 0) {
        final path = cacheInfo['path'] as String;
        if (await File(path).exists()) {
          return path;
        }
      }

      final tempPath = _createTempPath(type);
      await Directory(p.dirname(tempPath)).create(recursive: true);
      await _dio.download(fileUrl, tempPath);

      final contentMd5 = await calculateFileMD5(tempPath);
      final finalPath = _resolveOutputPath(type, contentMd5, fileUrl);
      final savedPath = await moveDownloadToCache(tempPath, finalPath);
      final size = await File(savedPath).length();

      await _mediaService.upsert({
        'url': fileUrl,
        'md5': contentMd5,
        'path': savedPath,
        'type': type.name,
        'size': size,
      });

      return savedPath;
    } catch (e) {
      print('[MediaManager] download failed: $fileUrl, error: $e');
      return null;
    }
  }

  /// [fileUrl] 完整远程 URL，先查 media 表再决定返回本地路径或远程 URL
  Future<String> get(CacheType type, String fileUrl) async {
    if (fileUrl.startsWith('file://') || fileUrl.startsWith('assets/')) {
      return fileUrl;
    }

    if (fileUrl.isEmpty) return fileUrl;

    if (!fileUrl.startsWith('http://') && !fileUrl.startsWith('https://')) {
      return fileUrl;
    }

    await _ensureInitialized();

    if (_cacheFile.containsKey(fileUrl)) {
      return _cacheFile[fileUrl]!;
    }

    final cacheInfo = await _mediaService.getMediaByUrl(fileUrl);
    if (cacheInfo != null && cacheInfo['isDeleted'] == 0) {
      final path = cacheInfo['path'] as String;
      if (await File(path).exists()) {
        final localPath = 'file://$path';
        _cacheFile[fileUrl] = localPath;
        return localPath;
      }
    }

    _cacheFile[fileUrl] = fileUrl;
    add(type, fileUrl).catchError((_) => null);

    return fileUrl;
  }
}

final mediaManager = MediaManager();
