#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';
import 'package:colorize/colorize.dart';
import '../src/commands/command_runner.dart';

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
    await runner.run(remainingArgs);
  } catch (e) {
    _handleError(e);
  }
}

void _showHelp(ArgParser parser) {
  print(Colorize('Flutter Maps Integration CLI').bold().green().toString());
  print('');
  print(
    'A command-line tool for integrating Google Maps into Flutter projects.',
  );
  print('');
  print('Usage: flutter_maps_integrate <command> [options]');
  print('');
  print('Global options:');
  print(parser.usage);
  print('');
  print('Commands:');
  print('  validate <project_path>  Validate current integration status');
  print('  config <subcommand>      Manage configuration files');
  print('  integrate <project_path> Integrate Google Maps into project');
  print('');
  print('For more information about a command:');
  print('  flutter_maps_integrate <command> --help');
}

void _showVersion() {
  print(
    Colorize('Flutter Maps Integration CLI v1.0.0').bold().blue().toString(),
  );
}

void _handleError(dynamic error) {
  print(Colorize('Error: $error').red().toString());
  print('');
  print('For help, run: flutter_maps_integrate --help');

  exit(1);
}
