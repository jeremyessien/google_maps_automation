import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import '../models/config.dart';

class ConfigService {
  static const String configFileName = 'flutter_maps_config.yaml';

  static File? findConfigFile({String? startPath}) {
    final searchPath = startPath ?? Directory.current.path;
    final dir = Directory(searchPath);
    if (!dir.existsSync()) return null;

    final configFile = File(path.join(searchPath, configFileName));
    if (configFile.existsSync()) return configFile;

    var currentDir = dir;
    for (int i = 0; i < 3; i++) {
      final parent = currentDir.parent;
      if (!parent.existsSync()) break;

      final parentConfig = File(path.join(parent.path, configFileName));
      if (parentConfig.existsSync()) return parentConfig;

      currentDir = parent;
    }

    return null;
  }

  static Future<Config> loadConfig(File configFile) async {
    try {
      final content = await configFile.readAsString();
      final yamlMap = loadYaml(content) as Map<String, dynamic>;
      final json = _yamlToJson(yamlMap); //todod: create method
      return Config.fromJson(json);
    } catch (e) {
      throw Exception('Failed to load config from $configFile: $e');
    }
  }

  static Future<void> saveConfig(Config config, File configFile) async {
    try {
      final jsonMap = config.toJson();
      final yamlString = _jsonToYaml(jsonMap);
      await configFile.writeAsString(yamlString);
    } catch (e) {
      throw ConfigException('Failed to save config to $configFile: $e');
    }
  }

  static Future<File> createDefaultConfig([String? directory]) async {
    final config = Config.defaultConfig();
    final configDir = directory ?? Directory.current.path;
    final configFile = File(path.join(configDir, configFileName));
    await saveConfig(config, configFile);
    return configFile;
  }

  static void validateConfig(Config config) {
    final errors = <String>[];
    if (config.project.path.isEmpty) {
      errors.add('Project path cannot be empty');
    }

    if (!config.apiKey.skipValidation) {
      if (config.platforms.android &&
          (config.apiKey.android?.isEmpty ?? true)) {
        errors.add('Android API key is required');
      }
      if (config.platforms.ios && (config.apiKey.ios?.isEmpty ?? true)) {
        errors.add('iOS API key is required');
      }
    }
    if (!config.platforms.android && !config.platforms.ios) {
      errors.add('At least one platform must be enabled');
    }
    if (config.platforms.minSdkVersion < 16) {
      errors.add('Minimum SDK version must be at least 16');
    }
    if (errors.isNotEmpty) {
      throw ConfigException(
        'Configuration validation failed: ${errors.join(', ')}',
      );
    }
  }

  static dynamic _yamlToJson(dynamic yaml) {
    if (yaml is Map) {
      return Map<String, dynamic>.fromEntries(
        yaml.entries.map((e) => MapEntry(e.key.toString(), _yamlToJson(e.value)))
      );
    } else if (yaml is List) {
      return yaml.map((e) => _yamlToJson(e)).toList();
    } else {
      return yaml;
    }
  }

static String _jsonToYaml(Map<String, dynamic> json) {
    // Simple YAML conversion - in a real app, you might want a more robust solution
    final buffer = StringBuffer();
    _writeYamlMap(json, buffer, 0);
    return buffer.toString();
  }
  
  /// Recursively write YAML map
  static void _writeYamlMap(Map<String, dynamic> map, StringBuffer buffer, int indent) {
    final indentStr = '  ' * indent;
    
    for (final entry in map.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (value is Map<String, dynamic>) {
        buffer.writeln('$indentStr$key:');
        _writeYamlMap(value, buffer, indent + 1);
      } else if (value is List) {
        buffer.writeln('$indentStr$key:');
        for (final item in value) {
          buffer.writeln('$indentStr  - $item');
        }
      } else {
        buffer.writeln('$indentStr$key: $value');
      }
    }
}
}



class ConfigException implements Exception {
  final String message;
  ConfigException(this.message);

  @override
  String toString() => 'ConfigException: $message';
}
