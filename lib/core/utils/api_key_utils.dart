
import 'dart:developer';
import 'dart:io';

class ApiKeyUtils {

  static bool isValidApiKey(String? apiKey) {
    if (apiKey == null || apiKey.isEmpty) {
      return false;
    }

    return apiKey.length >= 20 && !apiKey.contains(' ');
  }


  static Future<bool> isApiKeyConfiguredInAndroid(
      String projectPath,
      String manifestPath,
      ) async {
    try {
      final file = File('$projectPath${Platform.pathSeparator}$manifestPath');
      if (!await file.exists()) {
        return false;
      }

      final content = await file.readAsString();
      // Look for the API key meta-data in AndroidManifest.xml
      return content.contains('com.google.android.geo.API_KEY') &&
          !content.contains('YOUR_API_KEY_HERE');
    } catch (e) {
      print('Error checking for API key in AndroidManifest: $e');
      return false;
    }
  }


  static Future<bool> isApiKeyConfiguredInIOS(
      String projectPath,
      String plistPath,
      ) async {
    try {
      final file = File('$projectPath${Platform.pathSeparator}$plistPath');
      if (!await file.exists()) {
        return false;
      }

      final content = await file.readAsString();

      return content.contains('GoogleMapsApiKey') &&
          !content.contains('YOUR_API_KEY_HERE');
    } catch (e) {
      log('Error checking for API key in Info.plist: $e');
      return false;
    }
  }
}