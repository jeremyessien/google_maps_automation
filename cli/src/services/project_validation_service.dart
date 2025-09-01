import 'dart:io';
import 'package:path/path.dart' as path;

import '../models/project_validation_results.dart';

/// Service for validating Flutter projects
///
/// This service checks:
/// - Project structure validity
/// - Google Maps integration status
/// - Platform configuration readiness
/// - Dependencies and permissions
class ProjectValidationService {
  /// Validate if a directory is a valid Flutter project
  static Future<ProjectValidationResult> validateProject(
    String projectPath,
  ) async {
    final result = ProjectValidationResult(projectPath: projectPath);

    try {
      // Check if directory exists
      final dir = Directory(projectPath);
      if (!await dir.exists()) {
        result.addError('Project directory does not exist: $projectPath');
        return result;
      }

      // Check for pubspec.yaml
      final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
      if (!await pubspecFile.exists()) {
        result.addError('No pubspec.yaml found - not a valid Flutter project');
        return result;
      }

      result.isValidFlutterProject = true;

      // Check for Google Maps integration
      await _checkGoogleMapsIntegration(projectPath, result);

      // Check platform configurations
      await _checkPlatformConfigurations(projectPath, result);

      // Check project structure
      await _checkProjectStructure(projectPath, result);
    } catch (e) {
      result.addError('Error validating project: $e');
    }

    return result;
  }

  /// Check if Google Maps is already integrated
  static Future<void> _checkGoogleMapsIntegration(
    String projectPath,
    ProjectValidationResult result,
  ) async {
    try {
      final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
      final content = await pubspecFile.readAsString();

      // Check for google_maps_flutter dependency
      if (content.contains('google_maps_flutter:')) {
        result.googleMapsIntegrated = true;
        result.addInfo('Google Maps Flutter package is already integrated');
      } else {
        result.addInfo('Google Maps Flutter package is not integrated');
      }

      // Check for Google Maps usage in code
      await _checkGoogleMapsUsage(projectPath, result);
    } catch (e) {
      result.addWarning('Could not check Google Maps integration: $e');
    }
  }

  /// Check for Google Maps usage in Dart files
  static Future<void> _checkGoogleMapsUsage(
    String projectPath,
    ProjectValidationResult result,
  ) async {
    try {
      final libDir = Directory(path.join(projectPath, 'lib'));
      if (!await libDir.exists()) return;

      bool foundUsage = false;
      await for (final file in libDir.list(recursive: true)) {
        if (file is File && file.path.endsWith('.dart')) {
          final content = await file.readAsString();
          if (content.contains('GoogleMap') ||
              content.contains('google_maps_flutter')) {
            foundUsage = true;
            break;
          }
        }
      }

      if (foundUsage) {
        result.googleMapsUsed = true;
        result.addInfo('Google Maps is being used in the project code');
      }
    } catch (e) {
      result.addWarning('Could not check Google Maps usage: $e');
    }
  }

  /// Check platform-specific configurations
  static Future<void> _checkPlatformConfigurations(
    String projectPath,
    ProjectValidationResult result,
  ) async {
    // Check Android configuration
    final androidDir = Directory(path.join(projectPath, 'android'));
    if (await androidDir.exists()) {
      result.androidPlatformExists = true;
      await _checkAndroidConfiguration(projectPath, result);
    }

    // Check iOS configuration
    final iosDir = Directory(path.join(projectPath, 'ios'));
    if (await iosDir.exists()) {
      result.iosPlatformExists = true;
      await _checkIosConfiguration(projectPath, result);
    }
  }

  /// Check Android-specific configuration
  static Future<void> _checkAndroidConfiguration(
    String projectPath,
    ProjectValidationResult result,
  ) async {
    try {
      // Check AndroidManifest.xml
      final manifestFile = File(
        path.join(projectPath, 'android/app/src/main/AndroidManifest.xml'),
      );

      if (await manifestFile.exists()) {
        final content = await manifestFile.readAsString();

        if (content.contains('com.google.android.geo.API_KEY')) {
          result.androidApiKeyConfigured = true;
          result.addInfo('Android API key is configured');
        } else {
          result.addInfo('Android API key is not configured');
        }

        if (content.contains('android.permission.INTERNET')) {
          result.androidInternetPermission = true;
        } else {
          result.addWarning(
            'Internet permission not found in AndroidManifest.xml',
          );
        }

        if (content.contains('android.permission.ACCESS_FINE_LOCATION')) {
          result.androidLocationPermission = true;
        } else {
          result.addWarning(
            'Location permission not found in AndroidManifest.xml',
          );
        }
      }

      // Check build.gradle
      final buildGradleFile = File(
        path.join(projectPath, 'android/app/build.gradle'),
      );

      if (await buildGradleFile.exists()) {
        final content = await buildGradleFile.readAsString();
        final minSdkMatch = RegExp(
          r'minSdkVersion\s+(\d+)',
        ).firstMatch(content);

        if (minSdkMatch != null) {
          final minSdk = int.parse(minSdkMatch.group(1)!);
          result.androidMinSdkVersion = minSdk;

          if (minSdk < 20) {
            result.addWarning(
              'Android minSdkVersion ($minSdk) is below recommended (20)',
            );
          }
        }
      }
    } catch (e) {
      result.addWarning('Could not check Android configuration: $e');
    }
  }

  /// Check iOS-specific configuration
  static Future<void> _checkIosConfiguration(
    String projectPath,
    ProjectValidationResult result,
  ) async {
    try {
      // Check Info.plist
      final plistFile = File(path.join(projectPath, 'ios/Runner/Info.plist'));

      if (await plistFile.exists()) {
        final content = await plistFile.readAsString();

        if (content.contains('GoogleMapsApiKey')) {
          result.iosApiKeyConfigured = true;
          result.addInfo('iOS API key is configured');
        } else {
          result.addInfo('iOS API key is not configured');
        }

        if (content.contains('NSLocationWhenInUseUsageDescription')) {
          result.iosLocationPermission = true;
        } else {
          result.addWarning(
            'Location usage description not found in Info.plist',
          );
        }

        if (content.contains('io.flutter.embedded_views_preview')) {
          result.iosEmbeddedViewsEnabled = true;
        } else {
          result.addWarning('Embedded views preview not enabled in Info.plist');
        }
      }
    } catch (e) {
      result.addWarning('Could not check iOS configuration: $e');
    }
  }

  /// Check project structure
  static Future<void> _checkProjectStructure(
    String projectPath,
    ProjectValidationResult result,
  ) async {
    try {
      // Check for lib directory
      final libDir = Directory(path.join(projectPath, 'lib'));
      if (await libDir.exists()) {
        result.libDirectoryExists = true;
      } else {
        result.addError('lib directory not found');
      }

      // Check for main.dart
      final mainFile = File(path.join(projectPath, 'lib/main.dart'));
      if (await mainFile.exists()) {
        result.mainDartExists = true;
      } else {
        result.addError('main.dart not found in lib directory');
      }

      // Check for test directory
      final testDir = Directory(path.join(projectPath, 'test'));
      if (await testDir.exists()) {
        result.testDirectoryExists = true;
      }
    } catch (e) {
      result.addWarning('Could not check project structure: $e');
    }
  }
}
