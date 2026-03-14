import 'media_cache_manager.dart';
import 'cache_config.dart';

/// 缓存服务
/// 
/// 统一的缓存管理入口
/// - 图片缓存（cached_network_image）
/// - 文件缓存（flutter_cache_manager）
/// - 按用户隔离
/// - 自动清理
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  String? _currentUserId;
  bool _initialized = false;

  /// 是否已初始化
  bool get isInitialized => _initialized;

  /// 初始化缓存服务
  Future<void> init({String? userId}) async {
    if (_initialized && _currentUserId == userId) return;

    _currentUserId = userId;
    await mediaCacheManager.init(userId);
    _initialized = true;
  }

  /// 切换用户
  Future<void> switchUser(String? userId) async {
    if (_currentUserId == userId) return;
    
    _currentUserId = userId;
    await mediaCacheManager.switchUser(userId);
  }

  /// 获取当前用户ID
  String? get currentUserId => _currentUserId;

  /// 获取媒体缓存管理器
  MediaCacheManager get media => mediaCacheManager;

  /// 清除所有缓存
  Future<void> clearAll() async {
    await mediaCacheManager.clearAllCache();
  }

  /// 清除指定类型缓存
  Future<void> clearByType(CacheType type) async {
    await mediaCacheManager.clearCache(type);
  }

  /// 获取缓存大小（字节）
  Future<int> getCacheSize() async {
    return await mediaCacheManager.getCacheSize();
  }

  /// 获取格式化的缓存大小
  Future<String> getFormattedCacheSize() async {
    final size = await getCacheSize();
    return _formatBytes(size);
  }

  /// 格式化字节大小
  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (bytes.bitLength ~/ 10);
    if (i >= suffixes.length) i = suffixes.length - 1;
    return '${(bytes / (1 << (i * 10))).toStringAsFixed(2)} ${suffixes[i]}';
  }

  /// 检查是否需要清理缓存（超过最大限制）
  Future<bool> shouldCleanCache() async {
    final size = await getCacheSize();
    return size > CacheConfig.maxCacheSize;
  }

  /// 智能清理缓存
  Future<void> smartClean() async {
    final shouldClean = await shouldCleanCache();
    if (shouldClean) {
      await mediaCacheManager.cleanExpiredCache();
    }
  }
}

/// 全局缓存服务实例
final cacheService = CacheService();
