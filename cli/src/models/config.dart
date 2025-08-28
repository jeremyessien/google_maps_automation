import 'package:json_annotation/json_annotation.dart';
part 'config.g.dart';

/// Main configuration class for the Flutter Maps Integration CLI
///
/// This class represents the complete configuration that can be saved
/// to and loaded from a YAML file
@JsonSerializable()
class Config {
  /// Project-specific configuration
  final ProjectConfig project;

  /// API key configuration
  final ApiKeyConfig apiKey;

  /// Platform-specific settings
  final PlatformConfig platforms;

  /// Integration settings
  final IntegrationConfig integration;

  /// Output and logging settings
  final OutputConfig output;

  const Config({
    required this.project,
    required this.apiKey,
    required this.platforms,
    required this.integration,
    required this.output,
  });

  /// Create a default configuration
  factory Config.defaultConfig() {
    return Config(
      project: ProjectConfig.defaultConfig(),
      apiKey: ApiKeyConfig.defaultConfig(),
      platforms: PlatformConfig.defaultConfig(),
      integration: IntegrationConfig.defaultConfig(),
      output: OutputConfig.defaultConfig(),
    );
  }

  /// Create from JSON
  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}

/// Project-specific configuration
@JsonSerializable()
class ProjectConfig {
  /// Path to the Flutter project
  final String path;

  /// Project name (optional, auto-detected if not provided)
  final String? name;

  const ProjectConfig({required this.path, this.name});

  factory ProjectConfig.defaultConfig() {
    return const ProjectConfig(path: './');
  }

  factory ProjectConfig.fromJson(Map<String, dynamic> json) =>
      _$ProjectConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectConfigToJson(this);
}

/// API key configuration
@JsonSerializable()
class ApiKeyConfig {
  /// Android API key
  final String? android;

  /// iOS API key
  final String? ios;

  /// Skip API key validation
  final bool skipValidation;

  const ApiKeyConfig({this.android, this.ios, this.skipValidation = false});

  factory ApiKeyConfig.defaultConfig() {
    return const ApiKeyConfig();
  }

  factory ApiKeyConfig.fromJson(Map<String, dynamic> json) =>
      _$ApiKeyConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ApiKeyConfigToJson(this);
}

/// Platform-specific configuration
@JsonSerializable()
class PlatformConfig {
  /// Enable Android configuration
  final bool android;

  /// Enable iOS configuration
  final bool ios;

  /// Minimum SDK version for Android
  final int minSdkVersion;

  const PlatformConfig({
    this.android = true,
    this.ios = true,
    this.minSdkVersion = 20,
  });

  factory PlatformConfig.defaultConfig() {
    return const PlatformConfig();
  }

  factory PlatformConfig.fromJson(Map<String, dynamic> json) =>
      _$PlatformConfigFromJson(json);
  Map<String, dynamic> toJson() => _$PlatformConfigToJson(this);
}

/// Integration configuration
@JsonSerializable()
class IntegrationConfig {
  /// Add demo code to project
  final bool addDemo;

  /// Create backup before modifications
  final bool backupFiles;

  /// Preview changes without applying
  final bool dryRun;

  const IntegrationConfig({
    this.addDemo = true,
    this.backupFiles = true,
    this.dryRun = false,
  });

  factory IntegrationConfig.defaultConfig() {
    return const IntegrationConfig();
  }

  factory IntegrationConfig.fromJson(Map<String, dynamic> json) =>
      _$IntegrationConfigFromJson(json);
  Map<String, dynamic> toJson() => _$IntegrationConfigToJson(this);
}

/// Output and logging configuration
@JsonSerializable()
class OutputConfig {
  /// Enable verbose output
  final bool verbose;

  /// Log file path (optional)
  final String? logFile;

  /// Output format (text, json, yaml)
  final String format;

  const OutputConfig({
    this.verbose = false,
    this.logFile,
    this.format = 'text',
  });

  factory OutputConfig.defaultConfig() {
    return const OutputConfig();
  }

  factory OutputConfig.fromJson(Map<String, dynamic> json) =>
      _$OutputConfigFromJson(json);
  Map<String, dynamic> toJson() => _$OutputConfigToJson(this);
}
