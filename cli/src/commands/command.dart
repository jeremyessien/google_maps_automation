import 'dart:developer';

import 'package:args/args.dart';

abstract class Command {
  String get name;
  String get description;
  Future<void> execute(List<String> arguments);

  ArgParser get parser;

  void showHelp() {
    log('Help for command: $name ');
    log('Description: $description');
    log('');
    log('Usage: flutter_maps_integrate $name [options]');
    log('');
    log('Options:');
    log(parser.usage);
  }
}
