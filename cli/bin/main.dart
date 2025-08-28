#!/usr/bin/env dart

import 'dart:developer';
import 'dart:io';
import 'package:args/args.dart';
import 'package:colorize/colorize.dart';
import '../src/commands/command_runner.dart';
import '../src/commands/validate_command.dart';

void main(List<String> arguments) async {
  try {
    final parser = ArgParser()
      ..addFlag(
        'verbose',
        abbr: 'v',
        help: 'Enable verbose output for debugging',
        defaultsTo: false,
      )
      ..addFlag(
        'help',
        abbr: 'h',
        help: 'Show this help message',
        defaultsTo: false,
      )
      ..addFlag('version', help: 'Show version information', defaultsTo: false);

    final results = parser.parse(arguments);

    if (results['help']) {
      _showHelp(parser);
      return;
    }

    if (results['version']) {
      _showVersion();
      return;
    }

    final remainingArgs = results.rest;

    if (remainingArgs.isEmpty) {
      _showHelp(parser);
      return;
    }

    final runner = CommandRunner(verbose: results['verbose']);

    runner.registerCommand(ValidateCommand());

    await runner.run(remainingArgs);
  } catch (e) {
    _handleError(e);
  }
}

void _showHelp(ArgParser parser) {
  log('${Colorize('Flutter Maps Integration CLI').bold().green}');
  log('');
  log('A command-line tool for integrating Google Maps into Flutter projects.');
  log('');
  log('Usage: flutter_maps_integrate <command> [options]');
  log('');
  log('Global options:');
  log(parser.usage);
  log('');
  log('Commands:');
  log('  validate <project_path>  Validate current integration status');
  log('');
  log('For more information about a command:');
  log('  flutter_maps_integrate <command> --help');
}

void _showVersion() {
  log('${Colorize('Flutter Maps Integration CLI v1.0.0').bold().blue}');
}

void _handleError(dynamic error) {
  log('${Colorize('Error: $error').red}');
  log('');
  log('For help, run: flutter_maps_integrate --help');

  exit(1);
}
