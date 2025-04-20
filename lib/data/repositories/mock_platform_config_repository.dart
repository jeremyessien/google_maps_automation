import 'dart:async';

import '../../domain/entities/platform_config.dart';
import '../../domain/repositories/i_platform_config_repository.dart';
import '../models/platform_config_model.dart';

class MockPlatformConfigRepository implements IPlatformConfigRepository {
  @override
  Future<PlatformConfig> configureAndroidPlatform({
    required String projectPath,
    required String apiKey,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return PlatformConfigModel(androidConfigured: true);
  }

  @override
  Future<PlatformConfig> configureIosPlatform({
    required String projectPath,
    required String apiKey,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    return PlatformConfigModel(iosConfigured: true);
  }

  @override
  Future<PlatformConfig> configureBothPlatforms({
    required String projectPath,
    required String apiKey,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    await Future.delayed(const Duration(seconds: 2));

    return PlatformConfigModel(androidConfigured: true, iosConfigured: true);
  }
}
