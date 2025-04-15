
import 'package:process_run/process_run.dart';


class ProcessUtils {

  static Future<String> runPubGet(String projectPath) async {
    try {
      final shell = Shell(workingDirectory: projectPath);
      final result = await shell.run('flutter pub get');

      String output = '';
      for (final process in result) {
        output += process.stdout.toString();
        output += process.stderr.toString();
      }

      return output;
    } catch (e) {
      return 'Error running flutter pub get: $e';
    }
  }
}