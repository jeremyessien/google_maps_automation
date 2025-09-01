import 'package:args/args.dart';
import 'package:colorize/colorize.dart';
import '../models/project_validation_results.dart';
import '../services/project_validation_service.dart';
import 'command.dart';

class ValidateCommand extends Command {
  @override
  String get name => 'validate';

  @override
  String get description =>
      'Validate Flutter project structure and configuration';

  @override
  ArgParser get parser {
    final parser = ArgParser()
      ..addOption(
        'project-path',
        abbr: 'p',
        help: 'Path to the Flutter project',
        defaultsTo: '.',
      )
      ..addFlag(
        'verbose',
        abbr: 'v',
        help: 'Run verbose output',
        defaultsTo: false,
      )
      ..addFlag('json', help: 'Output in JSON format', defaultsTo: false);

    return parser;
  }

  @override
  Future<void> execute(List<String> args) async {
    final result = parser.parse(args);

    final projectPath = result['project-path'] as String;
    final verbose = result['verbose'] as bool;
    final jsonOutput = result['json'] as bool;

    if (verbose) {
      print('${Colorize('Validating project at path: $projectPath').yellow}');
    }

    try {
      final validationResult = await ProjectValidationService.validateProject(
        projectPath,
      );

      if (jsonOutput) {
        _printJsonOutput(validationResult);
      } else {
        _printHumanReadableOutput(validationResult, verbose);
      }
    } catch (e) {
      print('${Colorize('❌ Validation failed: $e').red}');
    }
  }

  /// Print human-readable validation output
  void _printHumanReadableOutput(ProjectValidationResult result, bool verbose) {
    print('');
    print('${Colorize('Project Validation Results').bold().blue()}');
    print('${Colorize('=' * 50).blue()}');
    print('Project: ${result.projectPath}');
    print('Status: ${result.summary}');
    print('');

    // Project structure
    print('${Colorize('Project Structure:').bold()}');
    print('  Flutter Project: ${result.isValidFlutterProject ? '✅' : '❌'}');
    print('  lib Directory: ${result.libDirectoryExists ? '✅' : '❌'}');
    print('  main.dart: ${result.mainDartExists ? '✅' : '❌'}');
    print('  test Directory: ${result.testDirectoryExists ? '✅' : '❌'}');
    print('');

    // Google Maps integration
    print('${Colorize('Google Maps Integration:').bold()}');
    print('  Package Integrated: ${result.googleMapsIntegrated ? '✅' : '❌'}');
    print('  Code Usage: ${result.googleMapsUsed ? '✅' : '❌'}');
    print('');

    // Platforms
    print('${Colorize('Platforms:').bold()}');
    print('  Android: ${result.androidPlatformExists ? '✅' : '❌'}');
    print('  iOS: ${result.iosPlatformExists ? '✅' : '❌'}');
    print('');

    // Android configuration
    if (result.androidPlatformExists) {
      print('${Colorize('Android Configuration:').bold()}');
      print('  API Key: ${result.androidApiKeyConfigured ? '✅' : '❌'}');
      print(
        '  Internet Permission: ${result.androidInternetPermission ? '✅' : '❌'}',
      );
      print(
        '  Location Permission: ${result.androidLocationPermission ? '✅' : '❌'}',
      );
      if (result.androidMinSdkVersion != null) {
        print('  Min SDK Version: ${result.androidMinSdkVersion}');
      }
      print('');
    }

    // iOS configuration
    if (result.iosPlatformExists) {
      print('${Colorize('iOS Configuration:').bold()}');
      print('  API Key: ${result.iosApiKeyConfigured ? '✅' : '❌'}');
      print(
        '  Location Permission: ${result.iosLocationPermission ? '✅' : '❌'}',
      );
      print('  Embedded Views: ${result.iosEmbeddedViewsEnabled ? '✅' : '❌'}');
      print('');
    }

    // Errors
    if (result.hasErrors) {
      print('${Colorize('Errors:').bold().red()}');
      for (final error in result.errors) {
        print('  ❌ $error');
      }
      print('');
    }

    // Warnings
    if (result.hasWarnings) {
      print('${Colorize('Warnings:').bold().yellow()}');
      for (final warning in result.warnings) {
        print('  ⚠️  $warning');
      }
      print('');
    }

    // Info messages
    if (result.info.isNotEmpty && verbose) {
      print('${Colorize('Info:').bold().blue()}');
      for (final info in result.info) {
        print('  ℹ️  $info');
      }
      print('');
    }

    // Summary
    print('${Colorize('Summary:').bold()}');
    if (result.isReadyForIntegration) {
      if (result.googleMapsIntegrated) {
        print(
          '${Colorize('✅ Google Maps is already integrated in this project').green()}',
        );
      } else {
        print(
          '${Colorize('✅ Project is ready for Google Maps integration').green()}',
        );
      }
    } else {
      print('${Colorize('❌ Project needs fixes before integration').red()}');
    }
  }

  /// Print JSON output for programmatic use
  void _printJsonOutput(ProjectValidationResult result) {
    final json = {
      'projectPath': result.projectPath,
      'summary': result.summary,
      'isValidFlutterProject': result.isValidFlutterProject,
      'isReadyForIntegration': result.isReadyForIntegration,
      'googleMapsIntegrated': result.googleMapsIntegrated,
      'googleMapsUsed': result.googleMapsUsed,
      'platforms': {
        'android': {
          'exists': result.androidPlatformExists,
          'apiKeyConfigured': result.androidApiKeyConfigured,
          'internetPermission': result.androidInternetPermission,
          'locationPermission': result.androidLocationPermission,
          'minSdkVersion': result.androidMinSdkVersion,
        },
        'ios': {
          'exists': result.iosPlatformExists,
          'apiKeyConfigured': result.iosApiKeyConfigured,
          'locationPermission': result.iosLocationPermission,
          'embeddedViewsEnabled': result.iosEmbeddedViewsEnabled,
        },
      },
      'structure': {
        'libDirectoryExists': result.libDirectoryExists,
        'mainDartExists': result.mainDartExists,
        'testDirectoryExists': result.testDirectoryExists,
      },
      'errors': result.errors,
      'warnings': result.warnings,
      'info': result.info,
    };

    print(json.toString());
  }
}
