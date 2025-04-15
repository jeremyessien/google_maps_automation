import 'package:equatable/equatable.dart';

abstract class PlatformConfigEvent extends Equatable {
  const PlatformConfigEvent();

  @override
  List<Object?> get props => [];
}

class ConfigureAndroidPlatform extends PlatformConfigEvent {
  final String projectPath;
  final String apiKey;

  const ConfigureAndroidPlatform({
    required this.projectPath,
    required this.apiKey,
  });

  @override
  List<Object> get props => [projectPath, apiKey];
}

class ConfigureIosPlatform extends PlatformConfigEvent {
  final String projectPath;
  final String apiKey;

  const ConfigureIosPlatform({required this.projectPath, required this.apiKey});

  @override
  List<Object> get props => [projectPath, apiKey];
}

class ConfigureBothPlatforms extends PlatformConfigEvent {
  final String projectPath;
  final String apiKey;

  const ConfigureBothPlatforms({
    required this.projectPath,
    required this.apiKey,
  });

  @override
  List<Object> get props => [projectPath, apiKey];
}
