// lib/core/utils/pubspec_utils.dart
import 'dart:developer';
import 'dart:io';

class PubspecUtils {
  static Future<bool> addPackageToPubspec({
    required String projectPath,
    required String packageName,
    String? version,
  }) async {
    try {
      final pubspecFile = File(
        '$projectPath${Platform.pathSeparator}pubspec.yaml',
      );
      final content = await pubspecFile.readAsString();

      final packageRegExp = RegExp(
        r'^(\s*)' + packageName + r'\s*:.*$',
        multiLine: true,
      );
      if (packageRegExp.hasMatch(content)) {
        // Package already exists
        return true;
      }

      final dependenciesRegExp = RegExp(
        r'^dependencies\s*:\s*$',
        multiLine: true,
      );
      final match = dependenciesRegExp.firstMatch(content);

      if (match == null) {
        return false;
      }

      final packageLine =
          version == null || version == 'latest'
              ? '  $packageName: ^latest'
              : '  $packageName: ^$version';

      final startPosition = match.end;
      final beforeDependencies = content.substring(0, startPosition);
      final afterDependencies = content.substring(startPosition);

      final newContent = '$beforeDependencies\n$packageLine$afterDependencies';

      await pubspecFile.writeAsString(newContent);
      return true;
    } catch (e) {
      log('Error adding package to pubspec: $e');
      return false;
    }
  }

  static Future<bool> isPackageInPubspec({
    required String projectPath,
    required String packageName,
  }) async {
    try {
      final pubspecFile = File(
        '$projectPath${Platform.pathSeparator}pubspec.yaml',
      );
      final content = await pubspecFile.readAsString();

      final packageRegExp = RegExp(
        r'^(\s*)' + packageName + r'\s*:.*$',
        multiLine: true,
      );
      return packageRegExp.hasMatch(content);
    } catch (e) {
      log('Error checking package in pubspec: $e');
      return false;
    }
  }
}
