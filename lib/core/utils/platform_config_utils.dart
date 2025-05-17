import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/material.dart';

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

  static Future<bool> updateAndroidGradle(String projectPath) async {
    try {
      final gradlePath =
          '$projectPath${Platform.pathSeparator}android${Platform.pathSeparator}app${Platform.pathSeparator}build.gradle';
      final gradleFile = File(gradlePath);

      if (!await gradleFile.exists()) {
        return false;
      }

      String gradleContent = await gradleFile.readAsString();

      final minSdkRegex = RegExp(r'minSdkVersion\s+(\d+)');
      final match = minSdkRegex.firstMatch(gradleContent);

      if (match != null) {
        final currentMinSdk = int.parse(match.group(1)!);

        if (currentMinSdk < 20) {
          gradleContent = gradleContent.replaceFirst(
            minSdkRegex,
            'minSdkVersion 20',
          );
          try {
            await gradleFile.writeAsString(gradleContent);
          } catch (e) {
            debugPrint('Failed to write to build.gradle: $e');
          }
        }
      }

      return true;
    } catch (e, stackTrace) {
      return false;
    }
  }
}
