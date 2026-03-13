import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppCacheManager extends CacheManager with ImageCacheManager {
  static const String _key = 'imageCacheKey';

  static final AppCacheManager _instance = AppCacheManager._internal();

  factory AppCacheManager() => _instance;

  AppCacheManager._internal()
      : super(
          Config(
            _key,
            maxNrOfCacheObjects: 300,
            stalePeriod: const Duration(days: 30),
            repo: JsonCacheInfoRepository(databaseName: _key),
            fileService: HttpFileService(),
          ),
        );
}
