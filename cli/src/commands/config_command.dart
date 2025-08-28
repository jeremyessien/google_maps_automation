import 'dart:developer';
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
  ArgParser get parser => argParser;

  ArgParser get argParser {
    final parser = ArgParser()
      ..addCommand('init')
      ..addCommand('show')
      ..addCommand('validate')
      ..addOption('file', abbr: 'f', help: 'Path to configuration file');

    return parser;
  }

  @override
  Future<void> execute(List<String> arguments) async {
    final results = argParser.parse(arguments);

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
      log(
        Colorize(
          '✅ Configuration file created successfully!',
        ).green().toString(),
      );
      log('Location: ${configFile.path}');
      log('');
      log('Edit this file to customize your settings, then run:');
      log('  flutter_maps_integrate config validate');
    } catch (e) {
      log(
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
          log(
            Colorize(
              '❌ Configuration file not found: $configPath',
            ).red().toString(),
          );
          return;
        }
      } else {
        configFile = ConfigService.findConfigFile();
        if (configFile == null) {
          log(
            Colorize(
              '❌ No configuration file found in current directory or parents',
            ).red().toString(),
          );
          log('');
          log('Create a new configuration file with:');
          log('  flutter_maps_integrate config init');
          return;
        }
      }

      final config = await ConfigService.loadConfig(configFile);

      log(
        Colorize(
          'Configuration File: ${configFile.path}',
        ).bold().blue().toString(),
      );
      log('');
      _printConfig(config);
    } catch (e) {
      log(Colorize('❌ Failed to load configuration: $e').red().toString());
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
          log(
            Colorize(
              '❌ Configuration file not found: $configPath',
            ).red().toString(),
          );
          return;
        }
      } else {
        configFile = ConfigService.findConfigFile();
        if (configFile == null) {
          log(Colorize('❌ No configuration file found').red().toString());
          return;
        }
      }

      final config = await ConfigService.loadConfig(configFile);
      ConfigService.validateConfig(config);

      log(Colorize('✅ Configuration is valid!').green().toString());
      log('File: ${configFile.path}');
    } catch (e) {
      log(Colorize('❌ Configuration validation failed: $e').red().toString());
    }
  }

  /// Print configuration in a readable format
  void _printConfig(Config config) {
    log('Project:');
    log('  Path: ${config.project.path}');
    log('  Name: ${config.project.name ?? 'Auto-detected'}');
    log('');

    log('API Keys:');
    log('  Android: ${config.apiKey.android ?? 'Not set'}');
    log('  iOS: ${config.apiKey.ios ?? 'Not set'}');
    log('  Skip Validation: ${config.apiKey.skipValidation}');
    log('');

    log('Platforms:');
    log('  Android: ${config.platforms.android}');
    log('  iOS: ${config.platforms.ios}');
    log('  Min SDK Version: ${config.platforms.minSdkVersion}');
    log('');

    log('Integration:');
    log('  Add Demo: ${config.integration.addDemo}');
    log('  Backup Files: ${config.integration.backupFiles}');
    log('  Dry Run: ${config.integration.dryRun}');
    log('');

    log('Output:');
    log('  Verbose: ${config.output.verbose}');
    log('  Log File: ${config.output.logFile ?? 'None'}');
    log('  Format: ${config.output.format}');
  }

  /// Show help for config command
  void _showHelp() {
    log(Colorize('Config Command Help').bold().green().toString());
    log('');
    log('Usage: flutter_maps_integrate config <subcommand> [options]');
    log('');
    log('Subcommands:');
    log('  init     Create a new configuration file with default values');
    log('  show     Display current configuration');
    log('  validate Check if configuration is valid');
    log('');
    log('Options:');
    log('  --file, -f    Path to configuration file');
    log('');
    log('Examples:');
    log('  flutter_maps_integrate config init');
    log('  flutter_maps_integrate config show');
    log('  flutter_maps_integrate config validate');
  }
}
