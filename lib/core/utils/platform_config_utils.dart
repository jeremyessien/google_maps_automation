import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

class PlatformConfigUtils {
  static Future<bool> configureAndroidManifest({
    required String projectPath,
    required String apiKey,
    bool skipIfConfigured = true,
  }) async {
    try {
      final manifestPath =
          '$projectPath${Platform.pathSeparator}android${Platform.pathSeparator}app${Platform.pathSeparator}src${Platform.pathSeparator}main${Platform.pathSeparator}AndroidManifest.xml';
      final manifestFile = File(manifestPath);

      if (!await manifestFile.exists()) {
        return false;
      }

      String manifestContent = await manifestFile.readAsString();

      if (skipIfConfigured &&
          manifestContent.contains('com.google.android.geo.API_KEY') &&
          !manifestContent.contains('YOUR_API_KEY_HERE')) {
        return true;
      }

      final hasApiKeyTag = manifestContent.contains(
        'com.google.android.geo.API_KEY',
      );

      if (hasApiKeyTag) {
        final regex = RegExp(
          r'<meta-data\s+android:name="com.google.android.geo.API_KEY"\s+android:value="[^"]*"\s*/>',
        );
        manifestContent = manifestContent.replaceFirst(
          regex,
          '<meta-data android:name="com.google.android.geo.API_KEY" android:value="$apiKey" />',
        );
      } else {
        final insertIndex = manifestContent.lastIndexOf('</application>');
        if (insertIndex == -1) {
          return false;
        }

        final apiKeyTag = '''
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="$apiKey" />
''';

        manifestContent =
            manifestContent.substring(0, insertIndex) +
            apiKeyTag +
            manifestContent.substring(insertIndex);
      }

      if (!manifestContent.contains('android.permission.INTERNET')) {
        final insertIndex = manifestContent.indexOf('<application');
        if (insertIndex == -1) {
          return false;
        }

        final permissions = '''
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
''';

        manifestContent =
            manifestContent.substring(0, insertIndex) +
            permissions +
            manifestContent.substring(insertIndex);
      }

      await manifestFile.writeAsString(manifestContent);
      return true;
    } catch (e) {
      dev.log('Error configuring AndroidManifest.xml: $e');
      return false;
    }
  }

  static Future<bool> configureIosPlist({
    required String projectPath,
    required String apiKey,
    bool skipIfConfigured = true,
  }) async {
    try {
      final plistPath =
          '$projectPath${Platform.pathSeparator}ios${Platform.pathSeparator}Runner${Platform.pathSeparator}Info.plist';
      final plistFile = File(plistPath);

      if (!await plistFile.exists()) {
        return false;
      }

      String plistContent = await plistFile.readAsString();

      if (skipIfConfigured &&
          plistContent.contains('GoogleMapsApiKey') &&
          !plistContent.contains('YOUR_API_KEY_HERE')) {
        return true;
      }

      final hasApiKeyEntry = plistContent.contains('GoogleMapsApiKey');

      if (hasApiKeyEntry) {
        final keyStartIndex = plistContent.indexOf(
          '<key>GoogleMapsApiKey</key>',
        );
        final valueStartIndex = plistContent.indexOf('<string>', keyStartIndex);
        final valueEndIndex = plistContent.indexOf(
          '</string>',
          valueStartIndex,
        );

        if (keyStartIndex != -1 &&
            valueStartIndex != -1 &&
            valueEndIndex != -1) {
          plistContent =
              plistContent.substring(0, valueStartIndex + 8) +
              apiKey +
              plistContent.substring(valueEndIndex);
        }
      } else {
        final insertIndex = plistContent.lastIndexOf('</dict>');
        if (insertIndex == -1) {
          return false;
        }

        final apiKeyEntry = '''
	<key>GoogleMapsApiKey</key>
	<string>$apiKey</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>This app needs access to location when open.</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>This app needs access to location when in the background.</string>
	<key>io.flutter.embedded_views_preview</key>
	<true/>
''';

        plistContent =
            plistContent.substring(0, insertIndex) +
            apiKeyEntry +
            plistContent.substring(insertIndex);
      }

      await plistFile.writeAsString(plistContent);
      return true;
    } catch (e) {
      dev.log('Error configuring iOS Info.plist: $e');
      return false;
    }
  }

  // static Future<bool> updateAndroidGradle(String projectPath) async {
  //   try {
  //     final gradlePath =
  //         '$projectPath${Platform.pathSeparator}android${Platform.pathSeparator}app${Platform.pathSeparator}build.gradle';
  //     final gradleFile = File(gradlePath);
  //     debugPrint('Search for build.gradle at : $gradlePath');

  //     if (!await gradleFile.exists()) {
  //       debugPrint('Build.gradle file not found at : $gradlePath');
  //       return false;
  //     }

  //     String gradleContent = await gradleFile.readAsString();

  //     debugPrint('Searching for min sdk version pattern');
  //     final minSdkRegex = RegExp(r'minSdkVersion\s+(\d+)');
  //     final match = minSdkRegex.firstMatch(gradleContent);

  //     if (match != null) {
  //       debugPrint('Found min sdk version match: ${match.group(0)}');
  //       final currentMinSdk = int.parse(match.group(1)!);
  //       debugPrint('Current min sdk version: $currentMinSdk');
  //       if (currentMinSdk < 20) {
  //         gradleContent = gradleContent.replaceFirst(
  //           minSdkRegex,
  //           'minSdkVersion 20',
  //         );
  //         try {
  //           await gradleFile.writeAsString(gradleContent);
  //           debugPrint('Sucessfully wrote updated content to build.gradle');
  //         } catch (e) {
  //           debugPrint('Failed to write to build.gradle: $e');
  //         }
  //       }
  //     }

  //     return true;
  //   } catch (e, stackTrace) {
  //     log('Error updating Android gradle settings: $e');
  //     log('Error stacktrace : $stackTrace');
  //     return false;
  //   }
  // }

  static Future<bool> updateAndroidGradle(String projectPath) async {
    try {
      // Path to build.gradle
      final gradlePath =
          '$projectPath${Platform.pathSeparator}android${Platform.pathSeparator}app${Platform.pathSeparator}build.gradle';
      dev.log('DEBUG: Looking for build.gradle at: $gradlePath');

      final gradleFile = File(gradlePath);
      final fileExists = await gradleFile.exists();
      dev.log('DEBUG: build.gradle exists: $fileExists');

      if (!fileExists) {
        dev.log('ERROR: build.gradle file not found at: $gradlePath');
        return false;
      }

      // Read current gradle content
      dev.log('DEBUG: Reading build.gradle content...');
      String gradleContent = await gradleFile.readAsString();
      dev.log(
        'DEBUG: build.gradle content length: ${gradleContent.length} bytes',
      );

      // Try to find the minSdkVersion line
      dev.log('DEBUG: Searching for minSdkVersion pattern...');
      final minSdkRegex = RegExp(r'minSdkVersion\s+(\d+)');
      final match = minSdkRegex.firstMatch(gradleContent);

      if (match != null) {
        dev.log('DEBUG: Found minSdkVersion match: ${match.group(0)}');
        final currentMinSdk = int.parse(match.group(1)!);
        dev.log('DEBUG: Current minSdkVersion: $currentMinSdk');

        if (currentMinSdk < 20) {
          dev.log(
            'DEBUG: Current minSdkVersion needs update from $currentMinSdk to 20',
          );
          // Update minSdkVersion to 20
          dev.log('DEBUG: Attempting to update build.gradle content...');
          gradleContent = gradleContent.replaceFirst(
            minSdkRegex,
            'minSdkVersion 20',
          );

          dev.log('DEBUG: Writing updated content back to build.gradle...');
          try {
            await gradleFile.writeAsString(gradleContent);
            dev.log(
              'DEBUG: Successfully wrote updated content to build.gradle',
            );
          } catch (writeError) {
            dev.log('ERROR: Failed to write to build.gradle: $writeError');
            return false;
          }
        } else {
          dev.log(
            'DEBUG: Current minSdkVersion ($currentMinSdk) is already >= 20, no update needed',
          );
        }
      } else {
        dev.log('DEBUG: Could not find minSdkVersion pattern in build.gradle');

        // Try alternative patterns
        dev.log('DEBUG: Trying alternative pattern "minSdk"...');
        final altRegex = RegExp(r'minSdk\s+(\d+)');
        final altMatch = altRegex.firstMatch(gradleContent);

        if (altMatch != null) {
          dev.log('DEBUG: Found alternative match: ${altMatch.group(0)}');
        } else {
          dev.log('DEBUG: No "minSdk" pattern found either');

          // Let's log the first 100 characters of defaultConfig section to understand the structure
          final defaultConfigIndex = gradleContent.indexOf('defaultConfig');
          if (defaultConfigIndex >= 0) {
            final section = gradleContent.substring(
              defaultConfigIndex,
              min(defaultConfigIndex + 200, gradleContent.length),
            );
            dev.log('DEBUG: defaultConfig section preview: $section');
          } else {
            dev.log('DEBUG: No defaultConfig section found in build.gradle');
          }
        }

        dev.log(
          'WARNING: Could not update minSdkVersion, but continuing anyway',
        );
      }

      return true;
    } catch (e, stackTrace) {
      print('ERROR: Exception updating Android gradle settings: $e');
      print('ERROR: Stack trace: $stackTrace');
      return false;
    }
  }
}
