import 'dart:io';
import 'package:path/path.dart' as path;

import '../models/integration_result.dart';

/// Service for integrating packages into Flutter projects
///
/// This service handles:
/// - Adding dependencies to pubspec.yaml
/// - Running Flutter commands safely
/// - Backup and rollback functionality
/// - Conflict resolution
class PackageIntegrationService {
  /// Integrate Google Maps Flutter package into a project
  static Future<IntegrationResult> integrateGoogleMaps(
    String projectPath,
  ) async {
    final result = IntegrationResult(projectPath: projectPath);

    try {
      if (!await _isValidFlutterProject(projectPath)) {
        result.addError('Not a valid Flutter project: $projectPath');
        return result;
      }

      result.isValidProject = true;

      // Check if already integrated
      final isAlreadyIntegrated = await _isGoogleMapsIntegrated(projectPath);
      if (isAlreadyIntegrated) {
        result.isAlreadyIntegrated = true;
        result.addInfo('Google Maps Flutter package is already integrated');
        return result;
      }

      // Create backup
      final backupCreated = await _createBackup(projectPath);
      if (backupCreated) {
        result.backupCreated = true;
        result.addInfo('Created backup of pubspec.yaml');
      }

      // Add dependency to pubspec.yaml
      final dependencyAdded = await _addGoogleMapsDependency(projectPath);
      if (!dependencyAdded) {
        result.addError('Failed to add Google Maps dependency to pubspec.yaml');
        return result;
      }

      result.dependencyAdded = true;
      result.addInfo('Added google_maps_flutter dependency to pubspec.yaml');

      // Run flutter pub get
      final pubGetResult = await _runFlutterPubGet(projectPath);
      if (!pubGetResult.success) {
        result.addError('Failed to run flutter pub get: ${pubGetResult.error}');

        // Attempt rollback
        if (backupCreated) {
          await _restoreBackup(projectPath);
          result.addInfo('Rolled back changes due to pub get failure');
        }

        return result;
      }

      result.pubGetSuccessful = true;
      result.addInfo('Successfully ran flutter pub get');

      // Verify integration
      final isNowIntegrated = await _isGoogleMapsIntegrated(projectPath);
      if (isNowIntegrated) {
        result.integrationSuccessful = true;
        result.addInfo('Google Maps Flutter package successfully integrated');
      } else {
        result.addError('Integration verification failed');
      }
    } catch (e) {
      result.addError('Integration failed: $e');
    }

    return result;
  }

  /// Check if a directory is a valid Flutter project
  static Future<bool> _isValidFlutterProject(String projectPath) async {
    try {
      final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
      return await pubspecFile.exists();
    } catch (e) {
      return false;
    }
  }

  /// Check if Google Maps is already integrated
  static Future<bool> _isGoogleMapsIntegrated(String projectPath) async {
    try {
      final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
      final content = await pubspecFile.readAsString();
      return content.contains('google_maps_flutter:');
    } catch (e) {
      return false;
    }
  }

  /// Create backup of pubspec.yaml
  static Future<bool> _createBackup(String projectPath) async {
    try {
      final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
      final backupFile = File(path.join(projectPath, 'pubspec.yaml.backup'));

      if (await pubspecFile.exists()) {
        final content = await pubspecFile.readAsString();
        await backupFile.writeAsString(content);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Restore backup of pubspec.yaml
  static Future<bool> _restoreBackup(String projectPath) async {
    try {
      final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
      final backupFile = File(path.join(projectPath, 'pubspec.yaml.backup'));

      if (await backupFile.exists()) {
        final content = await backupFile.readAsString();
        await pubspecFile.writeAsString(content);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Add Google Maps dependency to pubspec.yaml
  static Future<bool> _addGoogleMapsDependency(String projectPath) async {
    try {
      final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
      final content = await pubspecFile.readAsString();

      // Check if already contains the dependency
      if (content.contains('google_maps_flutter:')) {
        return true; // Already added
      }

      // Find dependencies section
      final dependenciesRegex = RegExp(r'^dependencies:\s*$', multiLine: true);
      final match = dependenciesRegex.firstMatch(content);

      if (match == null) {
        return false; // No dependencies section found
      }

      // Insert the dependency after the dependencies: line
      final insertIndex = match.end;
      final beforeDependencies = content.substring(0, insertIndex);
      final afterDependencies = content.substring(insertIndex);

      final newContent =
          '$beforeDependencies\n  google_maps_flutter: ^2.5.3$afterDependencies';

      await pubspecFile.writeAsString(newContent);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Run flutter pub get command
  static Future<ProcessResult> _runFlutterPubGet(String projectPath) async {
    try {
      final result = await Process.run(
        'flutter',
        ['pub', 'get'],
        workingDirectory: projectPath,
        runInShell: true,
      );

      return ProcessResult(
        success: result.exitCode == 0,
        output: result.stdout.toString(),
        error: result.stderr.toString(),
        exitCode: result.exitCode,
      );
    } catch (e) {
      return ProcessResult(
        success: false,
        output: '',
        error: e.toString(),
        exitCode: -1,
      );
    }
  }

  /// Remove Google Maps integration (rollback)
  static Future<IntegrationResult> removeGoogleMaps(String projectPath) async {
    final result = IntegrationResult(projectPath: projectPath);

    try {
      // Check if integrated
      final isIntegrated = await _isGoogleMapsIntegrated(projectPath);
      if (!isIntegrated) {
        result.addInfo('Google Maps is not integrated in this project');
        return result;
      }

      // Restore backup if available
      final backupFile = File(path.join(projectPath, 'pubspec.yaml.backup'));
      if (await backupFile.exists()) {
        final restored = await _restoreBackup(projectPath);
        if (restored) {
          result.addInfo('Restored original pubspec.yaml from backup');

          // Run flutter pub get to update dependencies
          final pubGetResult = await _runFlutterPubGet(projectPath);
          if (pubGetResult.success) {
            result.removalSuccessful = true;
            result.addInfo('Successfully removed Google Maps integration');
          } else {
            result.addError('Failed to run flutter pub get after removal');
          }
        } else {
          result.addError('Failed to restore backup');
        }
      } else {
        result.addError('No backup found for rollback');
      }
    } catch (e) {
      result.addError('Removal failed: $e');
    }

    return result;
  }
}
