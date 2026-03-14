import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'cache_config.dart';

/// 媒体缓存管理器
/// 
/// 基于 flutter_cache_manager 实现
/// 支持按用户隔离、自动清理、LRU策略
class MediaCacheManager {
  static final MediaCacheManager _instance = MediaCacheManager._internal();
  factory MediaCacheManager() => _instance;
  MediaCacheManager._internal();

  String? _currentUserId;
  final Map<CacheType, CacheManager> _cacheManagers = {};

  /// 初始化
  Future<void> init(String? userId) async {
    _currentUserId = userId;
    await _initCacheManagers();
  }

  /// 初始化各类型缓存管理器
  Future<void> _initCacheManagers() async {
    final baseDir = await _getCacheBasePath();
    
    for (final type in CacheType.values) {
      final cacheDir = path.join(baseDir, _getTypeFolder(type));
      
      _cacheManagers[type] = CacheManager(
        Config(
          'beaver_cache_${type.name}_${_currentUserId ?? "public"}',
          stalePeriod: CacheConfig.cacheExpireTime,
          maxNrOfCacheObjects: 1000,
          fileService: HttpFileService(),
        ),
      );
    }
  }

  /// 获取缓存基础路径
  Future<String> _getCacheBasePath() async {
    final appDir = await getApplicationDocumentsDirectory();
    if (_currentUserId != null) {
      return path.join(appDir.path, 'users', _currentUserId!, 'cache');
    }
    return path.join(appDir.path, 'cache');
  }

  /// 获取类型对应的文件夹名
  String _getTypeFolder(CacheType type) {
    switch (type) {
      case CacheType.image:
        return 'images';
      case CacheType.video:
        return 'videos';
      case CacheType.voice:
        return 'voices';
      case CacheType.avatar:
        return 'avatars';
      case CacheType.file:
        return 'files';
    }
  }

  /// 根据文件扩展名获取缓存类型
  CacheType _getCacheTypeFromFileName(String fileName) {
    final ext = path.extension(fileName).toLowerCase();
    return fileTypeMapping[ext] ?? CacheType.file;
  }

  /// 获取文件
  Future<File?> getFile(String url, {CacheType? type}) async {
    final cacheType = type ?? _getCacheTypeFromFileName(url);
    final manager = _cacheManagers[cacheType];
    if (manager == null) return null;

    final fileInfo = await manager.getFileFromCache(url);
    return fileInfo?.file;
  }

  /// 下载并缓存文件
  Future<File?> downloadFile(String url, {CacheType? type}) async {
    final cacheType = type ?? _getCacheTypeFromFileName(url);
    final manager = _cacheManagers[cacheType];
    if (manager == null) return null;

    try {
      final fileInfo = await manager.downloadFile(url);
      return fileInfo.file;
    } catch (e) {
      return null;
    }
  }

  /// 获取缓存文件路径
  Future<String?> getFilePath(String url, {CacheType? type}) async {
    final file = await getFile(url, type: type);
    return file?.path;
  }

  /// 检查文件是否已缓存
  Future<bool> isCached(String url, {CacheType? type}) async {
    final file = await getFile(url, type: type);
    return file != null && await file.exists();
  }

  /// 清除指定类型的缓存
  Future<void> clearCache(CacheType type) async {
    final manager = _cacheManagers[type];
    if (manager != null) {
      await manager.emptyCache();
    }
  }

  /// 清除所有缓存
  Future<void> clearAllCache() async {
    for (final manager in _cacheManagers.values) {
      await manager.emptyCache();
    }
  }

  /// 获取缓存大小
  Future<int> getCacheSize() async {
    int totalSize = 0;
    final baseDir = await _getCacheBasePath();
    final dir = Directory(baseDir);
    
    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    }
    
    return totalSize;
  }

  /// 清理过期缓存（自动按 LRU 策略）
  Future<void> cleanExpiredCache() async {
    for (final manager in _cacheManagers.values) {
      // flutter_cache_manager 会自动处理过期清理
      // 这里可以添加额外的清理逻辑
    }
  }

  /// 切换用户时调用
  Future<void> switchUser(String? newUserId) async {
    if (_currentUserId == newUserId) return;
    
    // 清空当前缓存管理器
    _cacheManagers.clear();
    
    // 重新初始化
    await init(newUserId);
  }
}

/// 全局媒体缓存管理器实例
final mediaCacheManager = MediaCacheManager();
