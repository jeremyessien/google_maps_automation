import '../../domain/entities/platform_config.dart';

class PlatformConfigModel extends PlatformConfig {
  PlatformConfigModel({
    super.androidConfigured,
    super.iosConfigured,
    super.errorMessage,
  });

  factory PlatformConfigModel.fromEntity(PlatformConfig entity) {
    return PlatformConfigModel(
      androidConfigured: entity.androidConfigured,
      iosConfigured: entity.iosConfigured,
      errorMessage: entity.errorMessage,
    );
  }

  PlatformConfigModel copyWith({
    bool? androidConfigured,
    bool? iosConfigured,
    String? errorMessage,
  }) {
    return PlatformConfigModel(
      androidConfigured: androidConfigured ?? this.androidConfigured,
      iosConfigured: iosConfigured ?? this.iosConfigured,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
