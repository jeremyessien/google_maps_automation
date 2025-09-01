/// Main configuration class for the Flutter Maps Integration CLI
///
/// This class represents the complete configuration that can be saved
/// to and loaded from a YAML file
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

  /// Convert to Map for YAML serialization
  Map<String, dynamic> toMap() {
    return {
      'project': project.toMap(),
      'apiKey': apiKey.toMap(),
      'platforms': platforms.toMap(),
      'integration': integration.toMap(),
      'output': output.toMap(),
    };
  }

  /// Create from Map (from YAML deserialization)
  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      project: ProjectConfig.fromMap(
        map['project'] as Map<String, dynamic>? ?? {},
      ),
      apiKey: ApiKeyConfig.fromMap(
        map['apiKey'] as Map<String, dynamic>? ?? {},
      ),
      platforms: PlatformConfig.fromMap(
        map['platforms'] as Map<String, dynamic>? ?? {},
      ),
      integration: IntegrationConfig.fromMap(
        map['integration'] as Map<String, dynamic>? ?? {},
      ),
      output: OutputConfig.fromMap(
        map['output'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

/// Project-specific configuration
class ProjectConfig {
  /// Path to the Flutter project
  final String path;

  /// Project name (optional, auto-detected if not provided)
  final String? name;

  const ProjectConfig({required this.path, this.name});

  factory ProjectConfig.defaultConfig() {
    return const ProjectConfig(path: './');
  }

  Map<String, dynamic> toMap() {
    return {'path': path, if (name != null) 'name': name};
  }

  factory ProjectConfig.fromMap(Map<String, dynamic> map) {
    return ProjectConfig(
      path: map['path'] as String? ?? './',
      name: map['name'] as String?,
    );
  }
}

/// API key configuration
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

  Map<String, dynamic> toMap() {
    return {
      if (android != null) 'android': android,
      if (ios != null) 'ios': ios,
      'skipValidation': skipValidation,
    };
  }

  factory ApiKeyConfig.fromMap(Map<String, dynamic> map) {
    return ApiKeyConfig(
      android: map['android'] as String?,
      ios: map['ios'] as String?,
      skipValidation: map['skipValidation'] as bool? ?? false,
    );
  }
}

/// Platform-specific configuration
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

  Map<String, dynamic> toMap() {
    return {'android': android, 'ios': ios, 'minSdkVersion': minSdkVersion};
  }

  factory PlatformConfig.fromMap(Map<String, dynamic> map) {
    return PlatformConfig(
      android: map['android'] as bool? ?? true,
      ios: map['ios'] as bool? ?? true,
      minSdkVersion: map['minSdkVersion'] as int? ?? 20,
    );
  }
}

/// Integration configuration
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

  Map<String, dynamic> toMap() {
    return {'addDemo': addDemo, 'backupFiles': backupFiles, 'dryRun': dryRun};
  }

  factory IntegrationConfig.fromMap(Map<String, dynamic> map) {
    return IntegrationConfig(
      addDemo: map['addDemo'] as bool? ?? true,
      backupFiles: map['backupFiles'] as bool? ?? true,
      dryRun: map['dryRun'] as bool? ?? false,
    );
  }
}

/// Output and logging configuration
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

  Map<String, dynamic> toMap() {
    return {
      'verbose': verbose,
      if (logFile != null) 'logFile': logFile,
      'format': format,
    };
  }

  factory OutputConfig.fromMap(Map<String, dynamic> map) {
    return OutputConfig(
      verbose: map['verbose'] as bool? ?? false,
      logFile: map['logFile'] as String?,
      format: map['format'] as String? ?? 'text',
    );
  }
}
