import '../../core/utils/platform_config_utils.dart';
import '../../domain/entities/platform_config.dart';
import '../../domain/repositories/i_platform_config_repository.dart';
import '../models/platform_config_model.dart';

class PlatformConfigRepository implements IPlatformConfigRepository {
  @override
  Future<PlatformConfig> configureAndroidPlatform({
    required String projectPath,
    required String apiKey,
  }) async {
    try {
      final manifestSuccess =
          await PlatformConfigUtils.configureAndroidManifest(
            projectPath: projectPath,
            apiKey: apiKey,
          );

      final gradleSuccess = await PlatformConfigUtils.updateAndroidGradle(
        projectPath,
      );

      if (!manifestSuccess) {
        return PlatformConfigModel(
          androidConfigured: false,
          errorMessage: 'Failed to configure AndroidManifest.xml',
        );
      }

      if (!gradleSuccess) {
        return PlatformConfigModel(
          androidConfigured: false,
          errorMessage: 'Failed to update Android Gradle settings',
        );
      }

      return PlatformConfigModel(androidConfigured: true);
    } catch (e) {
      return PlatformConfigModel(
        androidConfigured: false,
        errorMessage: 'Error configuring Android: $e',
      );
    }
  }

  @override
  Future<PlatformConfig> configureIosPlatform({
    required String projectPath,
    required String apiKey,
  }) async {
    try {
      final plistSuccess = await PlatformConfigUtils.configureIosPlist(
        projectPath: projectPath,
        apiKey: apiKey,
      );

      if (!plistSuccess) {
        return PlatformConfigModel(
          iosConfigured: false,
          errorMessage: 'Failed to configure iOS Info.plist',
        );
      }

      return PlatformConfigModel(iosConfigured: true);
    } catch (e) {
      return PlatformConfigModel(
        iosConfigured: false,
        errorMessage: 'Error configuring iOS: $e',
      );
    }
  }

  @override
  Future<PlatformConfig> configureBothPlatforms({
    required String projectPath,
    required String apiKey,
  }) async {
    try {
      final androidConfig = await configureAndroidPlatform(
        projectPath: projectPath,
        apiKey: apiKey,
      );

      final iosConfig = await configureIosPlatform(
        projectPath: projectPath,
        apiKey: apiKey,
      );

      return PlatformConfigModel(
        androidConfigured: androidConfig.androidConfigured,
        iosConfigured: iosConfig.iosConfigured,
        errorMessage: androidConfig.errorMessage ?? iosConfig.errorMessage,
      );
    } catch (e) {
      return PlatformConfigModel(
        errorMessage: 'Error configuring platforms: $e',
      );
    }
  }
}
