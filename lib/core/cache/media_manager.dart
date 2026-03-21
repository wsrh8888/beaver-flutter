import 'dart:io';
import 'package:beaver/types/cache.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:beaver/core/database/services/index.dart';
import 'package:beaver/di/injection.dart';
import 'package:beaver/api/file.dart';
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
  final Set<String> _downloadingFiles = {};
  final Map<String, String> _cacheFile = {};
  bool _initialized = false;
  late Dio _dio;

  /// 初始化 Dio 并配置大厂开发环境通用的 SSL 绕过逻辑
  void _initDio() {
    _dio = Dio();
    // 适配 HTTPS 证书校验报错 (Hostname mismatch 等)
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true; // 开发环境允许所有证书
      return client;
    };
  }

  /// 初始化
  Future<void> init(String? userId) async {
    _userId = userId;
    final appDir = await getApplicationDocumentsDirectory();
    _cacheRoot = appDir.path;
    _cacheFile.clear();
    _downloadingFiles.clear();
    _initialized = true;
    print('[MediaFlow] [MediaManager] init: userId=$userId, root=$_cacheRoot');
  }

  /// 确保已初始化 (懒加载保护)
  Future<void> _ensureInitialized() async {
    if (!_initialized || _cacheRoot == null) {
      print('[MediaFlow] [MediaManager] auto-initializing...');
      await init(_userId);
    }
  }

  /// 获取媒体数据库服务
  MediaService get _mediaService => getIt<MediaService>();

  /// 添加缓存记录并执行下载
  Future<String?> add(CacheType type, String fileKey) async {
    await _ensureInitialized();
    
    final fileUrl = previewOnlineFileApi(fileKey);
    print('[MediaFlow] [MediaManager] add start: fileKey=$fileKey, url=$fileUrl');

    if (_downloadingFiles.contains(fileKey)) {
      print('[MediaFlow] [MediaManager] is already downloading: $fileKey');
      return fileUrl;
    }

    _downloadingFiles.add(fileKey);

    try {
      final subPath = CachePathConfig.getRelativePath(type, _userId ?? 'public');
      final outputPath = p.join(_cacheRoot!, subPath, fileKey);
      print('[MediaFlow] [MediaManager] outputPath: $outputPath');

      final file = File(outputPath);
      if (await file.exists()) {
        print('[MediaFlow] [MediaManager] file already exists, updating DB index...');
        await _mediaService.batchCreate({
          'mediaList': [
            {
              'fileKey': fileKey,
              'path': outputPath,
              'type': type.name,
              'size': await file.length(),
            },
          ],
        });
        return outputPath;
      }

      // 创建目录
      await Directory(p.dirname(outputPath)).create(recursive: true);

      // 下载文件 (这里已经绕过了证书限制)
      print('[MediaFlow] [MediaManager] dio downloading: $fileUrl -> $outputPath');
      await _dio.download(fileUrl, outputPath);
      print('[MediaFlow] [MediaManager] download success: $fileKey');

      // 保存到数据库
      print('[MediaFlow] [MediaManager] saving to DB...');
      await _mediaService.batchCreate({
        'mediaList': [
          {
            'fileKey': fileKey,
            'path': outputPath,
            'type': type.name,
            'size': await File(outputPath).length(),
          },
        ],
      });
      print('[MediaFlow] [MediaManager] DB record created: $fileKey');

      return outputPath;
    } catch (e) {
      print('[MediaFlow] [MediaManager] Error in add($fileKey): $e');
      return fileUrl;
    } finally {
      _downloadingFiles.remove(fileKey);
    }
  }

  /// 获取缓存文件路径
  Future<String> get(CacheType type, String fileKey) async {
    await _ensureInitialized();
    
    final fileUrl = previewOnlineFileApi(fileKey);
    print('[MediaFlow] [MediaManager] get start: fileKey=$fileKey');

    if (_cacheFile.containsKey(fileKey)) {
      print('[MediaFlow] [MediaManager] memory cache hit: $fileKey');
      return _cacheFile[fileKey]!;
    }

    // 先查数据库
    print('[MediaFlow] [MediaManager] DB query start: $fileKey');
    final cacheInfo = await _mediaService.getMediaByFileKey({'fileKey': fileKey});
    
    if (cacheInfo != null && cacheInfo['isDeleted'] == 0) {
      final path = cacheInfo['path'] as String;
      print('[MediaFlow] [MediaManager] DB record found: $path');
      if (await File(path).exists()) {
        _cacheFile[fileKey] = 'file://$path';
        return 'file://$path';
      } else {
        print('[MediaFlow] [MediaManager] DB points to file that does NOT exist: $path');
      }
    } else {
      print('[MediaFlow] [MediaManager] No DB record for: $fileKey');
    }

    // 没有缓存，异步下载
    print('[MediaFlow] [MediaManager] fallback to online URL, triggering async download');
    add(type, fileKey).catchError((e) {
      print('[MediaFlow] [MediaManager] async add error: $e');
    });

    return fileUrl;
  }
}

final mediaManager = MediaManager();
