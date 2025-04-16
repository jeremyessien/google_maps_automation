import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

class DemoIntegrationUtils {
  static Future<String?> findMainDartFile(String projectPath) async {
    final possiblePaths = [
      '$projectPath${Platform.pathSeparator}lib${Platform.pathSeparator}main.dart',
      '$projectPath${Platform.pathSeparator}lib${Platform.pathSeparator}src${Platform.pathSeparator}main.dart',
    ];

    for (final path in possiblePaths) {
      final file = File(path);
      if (await file.exists()) {
        return path;
      }
    }

    final libDir = Directory('$projectPath${Platform.pathSeparator}lib');
    if (await libDir.exists()) {
      try {
        final files = await libDir.list(recursive: true).toList();
        for (final file in files) {
          if (file is File && file.path.endsWith('main.dart')) {
            return file.path;
          }
        }
      } catch (e) {
        log('Error searching for main.dart: $e');
      }
    }

    return null;
  }

  static Future<String?> createMapsExampleFile(String projectPath) async {
    try {
      final dirPath = '$projectPath${Platform.pathSeparator}lib';
      final filePath =
          '$dirPath${Platform.pathSeparator}google_maps_example.dart';

      final file = File(filePath);

      final codeContent = '''
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsExample extends StatefulWidget {
  const GoogleMapsExample({Key? key}) : super(key: key);

  @override
  State<GoogleMapsExample> createState() => _GoogleMapsExampleState();
}

class _GoogleMapsExampleState extends State<GoogleMapsExample> {
  GoogleMapController? mapController;
  final LatLng center = const LatLng(37.7749, -122.4194); // San Francisco
  
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Example'),
      ),
      body: GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
''';

      await file.writeAsString(codeContent);
      return filePath;
    } catch (e) {
      log('Error creating maps example file: $e');
      return null;
    }
  }

  static Future<bool> updateMainDartFile(
    String mainFilePath,
    String exampleImportPath,
  ) async {
    try {
      final mainFile = File(mainFilePath);
      String content = await mainFile.readAsString();

      final libDir = 'lib${Platform.pathSeparator}';
      final importPath = exampleImportPath.substring(
        exampleImportPath.lastIndexOf(libDir) + libDir.length,
      );

      final importName = importPath.replaceAll('.dart', '');

      final importStatement =
          "import 'package:${getPackageName(mainFilePath)}/$importName.dart';";
      if (!content.contains(importStatement)) {
        final lastImportIndex = content.lastIndexOf('import ');
        final endOfImportLine = content.indexOf(';', lastImportIndex) + 1;

        if (lastImportIndex >= 0) {
          content =
              '${content.substring(0, endOfImportLine)}\n$importStatement${content.substring(endOfImportLine)}';
        } else {
          content = '$importStatement\n$content';
        }
      }

      final materialAppRegex = RegExp(r'MaterialApp\s*\(');
      final match = materialAppRegex.firstMatch(content);

      if (match != null) {
        final materialAppStartIndex = match.start;
        final closingParenIndex = findClosingParen(
          content,
          materialAppStartIndex + 'MaterialApp('.length - 1,
        );

        if (closingParenIndex != -1) {
          final hasHomeProperty = RegExp(r'home\s*:').hasMatch(
            content.substring(materialAppStartIndex, closingParenIndex),
          );

          if (!hasHomeProperty) {
            final insertIndex = closingParenIndex;
            content =
                '${content.substring(0, insertIndex)}home: const GoogleMapsExample(),${content.substring(insertIndex)}';
          } else {
            final homeRegex = RegExp(r'home\s*:\s*[^,)]+');
            content = content.replaceFirst(
              homeRegex,
              'home: const GoogleMapsExample()',
              materialAppStartIndex,
            );
          }
        }
      }

      await mainFile.writeAsString(content);
      return true;
    } catch (e) {
      log('Error updating main.dart: $e');
      return false;
    }
  }

  static String getPackageName(String mainFilePath) {
    try {
      final projectDir = mainFilePath.substring(
        0,
        mainFilePath.lastIndexOf('lib${Platform.pathSeparator}'),
      );
      final pubspecPath = '$projectDir${Platform.pathSeparator}pubspec.yaml';
      final pubspecFile = File(pubspecPath);
      final content = pubspecFile.readAsStringSync();

      final nameRegExp = RegExp(r'name:\s*([\w_]+)');
      final match = nameRegExp.firstMatch(content);

      if (match != null && match.groupCount >= 1) {
        return match.group(1)!;
      }

      return 'app';
    } catch (e) {
      log('Error getting package name: $e');
      return 'app';
    }
  }

  static int findClosingParen(String text, int openIndex) {
    int count = 1;
    for (int i = openIndex + 1; i < text.length; i++) {
      if (text[i] == '(') {
        count++;
      } else if (text[i] == ')') {
        count--;
      }

      if (count == 0) return i;
    }
    return -1;
  }
}
