import 'dart:developer';

import 'package:colorize/colorize.dart';

import 'command.dart';

class CommandRunner {
  final bool verbose;
  final Map<String, Command> _commands = {};

  CommandRunner({this.verbose = false}) {
    _registerCommands();
  }

  void _registerCommands() {
    registerCommand(ValidateCommand());
    registerCommand(ConfigCommand());
  }

  void registerCommand(Command command) {
    _commands[command.name] = command;
  }

  Future<void> run(List<String> arguments) async {
    if (arguments.isEmpty) {
      _showHelp();
      return;
    }

    final commandName = arguments[0];
    final commandArgs = arguments.skip(1).toList();

    if (commandName == 'help' ||
        commandName == '--help' ||
        commandName == '-h') {
      _showHelp();
      return;
    }

    final command = _commands[commandName];
    if (command == null) {
      _showUnknownCommand(commandName);
      return;
    }
    try {
      if (verbose) {
        log('${Colorize('Running command: $commandName').yellow}');
        log('${Colorize('Arguments: ${commandArgs.join(' ')}').yellow}');
      }

      await command.execute(commandArgs);
    } catch (e) {
      _handleCommandError(commandName, e);
    }
  }

  void _showHelp() {
    log("${Colorize('Available commands:').bold().green}");
    log("");
    if (_commands.isEmpty) {
      log(
        'No commands available. Please check the documentation for available commands.',
      );
      return;
    } else {
      for (final entry in _commands.entries) {
        log("  ${entry.key.padRight(15)} ${entry.value.description}");
      }
    }

    log('');
    log(
      'For detailed help on specific commands, use "flutter_maps_integrate <command> --help"',
    );
  }

  void _showUnknownCommand(String commandName) {
    log('${Colorize('Unknown command: $commandName').red}');
    log('');
    log('Available commands:');
    _showHelp();
  }

  void _handleCommandError(String commandName, dynamic error) {
    log("${Colorize('Error executing command: $commandName : $error').red}");
    if (verbose) {
      log('${Colorize('Stack trace:').yellow}');
      log(error);
    }
  }
}
