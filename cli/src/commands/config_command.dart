
import 'dart:io';
import 'package:args/args.dart';
import 'package:colorize/colorize.dart';

import '../models/config.dart';
import '../services/config_services.dart';
import 'command.dart';

class ConfigCommand extends Command {
  @override
  String get name => 'config';

  @override
  String get description => 'Manage configuration files';

  @override
  ArgParser get parser {
    final parser = ArgParser()
      ..addCommand('init')
      ..addCommand('show')
      ..addCommand('validate')
      ..addOption('file', abbr: 'f', help: 'Path to configuration file');

    return parser;
  }

  @override
  Future<void> execute(List<String> arguments) async {
    final results = parser.parse(arguments);

    if (results.command == null) {
      _showHelp();
      return;
    }

    switch (results.command!.name) {
      case 'init':
        await _handleInit(results);
        break;
      case 'show':
        await _handleShow(results);
        break;
      case 'validate':
        await _handleValidate(results);
        break;
      default:
        _showHelp();
    }
  }

  /// Handle 'config init' command
  Future<void> _handleInit(ArgResults results) async {
    final configPath = results['file'] as String?;

    try {
      final configFile = await ConfigService.createDefaultConfig(configPath);
      print(
        Colorize(
          '✅ Configuration file created successfully!',
        ).green().toString(),
      );
      print('Location: ${configFile.path}');
      print('');
      print('Edit this file to customize your settings, then run:');
      print('  flutter_maps_integrate config validate');
    } catch (e) {
      print(
        Colorize('❌ Failed to create configuration file: $e').red().toString(),
      );
    }
  }

  /// Handle 'config show' command
  Future<void> _handleShow(ArgResults results) async {
    final configPath = results['file'] as String?;

    try {
      File? configFile;

      if (configPath != null) {
        configFile = File(configPath);
        if (!configFile.existsSync()) {
          print(
            Colorize(
              '❌ Configuration file not found: $configPath',
            ).red().toString(),
          );
          return;
        }
      } else {
        configFile = ConfigService.findConfigFile();
        if (configFile == null) {
          print(
            Colorize(
              '❌ No configuration file found in current directory or parents',
            ).red().toString(),
          );
          print('');
          print('Create a new configuration file with:');
          print('  flutter_maps_integrate config init');
          return;
        }
      }

      final config = await ConfigService.loadConfig(configFile);

      print(
        Colorize(
          'Configuration File: ${configFile.path}',
        ).bold().blue().toString(),
      );
      print('');
      _printConfig(config);
    } catch (e) {
      print(Colorize('❌ Failed to load configuration: $e').red().toString());
    }
  }

  /// Handle 'config validate' command
  Future<void> _handleValidate(ArgResults results) async {
    final configPath = results['file'] as String?;

    try {
      File? configFile;

      if (configPath != null) {
        configFile = File(configPath);
        if (!configFile.existsSync()) {
          print(
            Colorize(
              '❌ Configuration file not found: $configPath',
            ).red().toString(),
          );
          return;
        }
      } else {
        configFile = ConfigService.findConfigFile();
        if (configFile == null) {
          print(Colorize('❌ No configuration file found').red().toString());
          return;
        }
      }

      final config = await ConfigService.loadConfig(configFile);
      ConfigService.validateConfig(config);

      print(Colorize('✅ Configuration is valid!').green().toString());
      print('File: ${configFile.path}');
    } catch (e) {
      print(Colorize('❌ Configuration validation failed: $e').red().toString());
    }
  }

  /// Print configuration in a readable format
  void _printConfig(Config config) {
    print('Project:');
    print('  Path: ${config.project.path}');
    print('  Name: ${config.project.name ?? 'Auto-detected'}');
    print('');

    print('API Keys:');
    print('  Android: ${config.apiKey.android ?? 'Not set'}');
    print('  iOS: ${config.apiKey.ios ?? 'Not set'}');
    print('  Skip Validation: ${config.apiKey.skipValidation}');
    print('');

    print('Platforms:');
    print('  Android: ${config.platforms.android}');
    print('  iOS: ${config.platforms.ios}');
    print('  Min SDK Version: ${config.platforms.minSdkVersion}');
    print('');

    print('Integration:');
    print('  Add Demo: ${config.integration.addDemo}');
    print('  Backup Files: ${config.integration.backupFiles}');
    print('  Dry Run: ${config.integration.dryRun}');
    print('');

    print('Output:');
    print('  Verbose: ${config.output.verbose}');
    print('  Log File: ${config.output.logFile ?? 'None'}');
    print('  Format: ${config.output.format}');
  }

  /// Show help for config command
  void _showHelp() {
    print(Colorize('Config Command Help').bold().green().toString());
    print('');
    print('Usage: flutter_maps_integrate config <subcommand> [options]');
    print('');
    print('Subcommands:');
    print('  init     Create a new configuration file with default values');
    print('  show     Display current configuration');
    print('  validate Check if configuration is valid');
    print('');
    print('Options:');
    print('  --file, -f    Path to configuration file');
    print('');
    print('Examples:');
    print('  flutter_maps_integrate config init');
    print('  flutter_maps_integrate config show');
    print('  flutter_maps_integrate config validate');
  }
}
