import '../entities/platform_config.dart';

abstract class IPlatformConfigRepository {
  Future<PlatformConfig> configureAndroidPlatform({
    required String projectPath,
    required String apiKey,
  });

  Future<PlatformConfig> configureIosPlatform({
    required String projectPath,
    required String apiKey,
  });

  Future<PlatformConfig> configureBothPlatforms({
    required String projectPath,
    required String apiKey,
  });
}
