import 'dart:developer';

import 'package:args/args.dart';
import 'package:colorize/colorize.dart';

import '../services/package_integration_service.dart';
import 'command.dart';

class IntegrateCommand extends Command {
  @override
  String get name => 'integrate';
  @override
  String get description => 'Integrate Google Maps into a Flutter project';

  @override
  ArgParser get parser {
    final parser = ArgParser()
      ..addOption(
        'project-path',
        abbr: 'p',
        help: 'The path to the Flutter project',
        defaultsTo: '.',
      )
      ..addFlag(
        'verbose',
        abbr: 'v',
        help: 'Run verbose output',
        defaultsTo: false,
      )
      ..addFlag(
        'force',
        abbr: 'f',
        help: 'Force the integration even if the project is already integrated',
        defaultsTo: false,
      )
      ..addFlag(
        'remove',
        help: 'Remove Google Maps integration',
        defaultsTo: false,
      )
      ..addFlag(
        'dry-run',
        help: 'Preview changes without applying',
        defaultsTo: false,
      );

    return parser;
  }

  @override
  Future<void> execute(List<String> args) async {
    final result = parser.parse(args);
    final projectPath = result['project-path'] as String;
    final verbose = result['verbose'] as bool;
    final force = result['force'] as bool;
    final remove = result['remove'] as bool;
    final dryRun = result['dry-run'] as bool;

    if (verbose) {
      log('${Colorize('Integration parameters:').yellow}');
      log('  Project path: $projectPath');
      log('  Force: $force');
      log('  Remove: $remove');
      log('  Dry run: $dryRun');
      log('');
    }
    try {
      if (remove) {
        await _handleRemove(projectPath, verbose, dryRun);
      } else {
        await _handleIntegrate(projectPath, verbose, force, dryRun);
      }
    } catch (e) {
      log('${Colorize('❌ Integration failed: $e').red}');
    }
  }

  Future<void> _handleRemove(
    String projectPath,
    bool verbose,
    bool dryRun,
  ) async {
    log('${Colorize('Removing Google Maps Flutter package...').blue()}');
    log('');

    if (dryRun) {
      log('${Colorize('DRY RUN MODE - No changes will be made').yellow()}');
      log('');
    }

    final removalResult = await PackageIntegrationService.removeGoogleMaps(
      projectPath,
    );

    _printIntegrationResult(removalResult, verbose);
  }

  Future<void> _handleIntegrate(
    String projectPath,
    bool verbose,
    bool force,
    bool dryRun,
  ) async {
    log('${Colorize('Integrating Google Maps Flutter package...').blue()}');
    log('');

    if (dryRun) {
      log('${Colorize('DRY RUN MODE - No changes will be made').yellow()}');
      log('');
    }

    final integrationResult =
        await PackageIntegrationService.integrateGoogleMaps(projectPath);

    _printIntegrationResult(integrationResult, verbose);

    if (integrationResult.isSuccessful) {
      log('');
      log('${Colorize('Next steps:').bold().green()}');
      log('  1. Configure API keys: flutter_maps_integrate configure');
      log('  2. Add platform configurations: flutter_maps_integrate configure');
      log('  3. Add example code: flutter_maps_integrate demo');
    }
  }

  void _printIntegrationResult(IntegrationResult result, bool verbose) {
    log('${Colorize('Integration Results').bold().blue()}');
    log('${Colorize('=' * 50).blue()}');
    log('Project: ${result.projectPath}');
    log('Status: ${result.summary}');
    log('');

    // Operation details
    if (result.isValidProject) {
      log('${Colorize('Operation Details:').bold()}');
      log('  Valid Project: ✅');
      log('  Already Integrated: ${result.isAlreadyIntegrated ? '✅' : '❌'}');
      log('  Backup Created: ${result.backupCreated ? '✅' : '❌'}');
      log('  Dependency Added: ${result.dependencyAdded ? '✅' : '❌'}');
      log('  Pub Get Successful: ${result.pubGetSuccessful ? '✅' : '❌'}');
      log(
        '  Integration Successful: ${result.integrationSuccessful ? '✅' : '❌'}',
      );
      log('  Removal Successful: ${result.removalSuccessful ? '✅' : '❌'}');
      log('');
    }

    // Errors
    if (result.hasErrors) {
      log('${Colorize('Errors:').bold().red()}');
      for (final error in result.errors) {
        log('  ❌ $error');
      }
      log('');
    }

    // Warnings
    if (result.hasWarnings) {
      log('${Colorize('Warnings:').bold().yellow()}');
      for (final warning in result.warnings) {
        log('  ⚠️  $warning');
      }
      log('');
    }

    // Info messages
    if (result.info.isNotEmpty) {
      log('${Colorize('Info:').bold().blue()}');
      for (final info in result.info) {
        log('  ℹ️  $info');
      }
      log('');
    }

    // Final status
    if (result.isSuccessful) {
      log('${Colorize('✅ Operation completed successfully!').green()}');
    } else if (result.hasErrors) {
      log('${Colorize('❌ Operation failed. Check errors above.').red()}');
    } else {
      log('${Colorize('⚠️  Operation completed with warnings.').yellow()}');
    }
  }
}
