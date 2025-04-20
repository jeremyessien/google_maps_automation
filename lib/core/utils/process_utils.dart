import 'dart:io';

class ProcessUtils {
  static Future<String> runPubGet(String projectPath) async {
    try {
      final result = await Process.run(
        'flutter',
        ['pub', 'get'],
        workingDirectory: projectPath,
        runInShell: true,
      );

      String output = '';
      output += result.stdout.toString();
      output += result.stderr.toString();

      return output;
    } catch (e) {
      return 'Error running flutter pub get: $e';
    }
  }
}
