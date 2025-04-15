
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';


class FileUtils {

  static Future<String?> pickDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    return selectedDirectory;
  }


  static bool isFlutterProject(String directoryPath) {
    final pubspecFile = File('$directoryPath${Platform.pathSeparator}pubspec.yaml');
    return pubspecFile.existsSync();
  }


  static Future<String?> readPubspecFile(String directoryPath) async {
    try {
      final pubspecFile = File('$directoryPath${Platform.pathSeparator}pubspec.yaml');
      if (await pubspecFile.exists()) {
        return await pubspecFile.readAsString();
      }
      return null;
    } catch (e) {
      log('Error reading pubspec.yaml: $e');
      return null;
    }
  }
}