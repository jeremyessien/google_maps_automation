import 'package:colorize/colorize.dart';

import 'command.dart';
import 'config_command.dart';
import 'integrate_command.dart';
import 'validate_command.dart';

class CommandRunner {
  final bool verbose;
  final Map<String, Command> _commands = {};

  CommandRunner({this.verbose = false}) {
    _registerCommands();
  }

  void _registerCommands() {
    registerCommand(ValidateCommand());
    registerCommand(ConfigCommand());
    registerCommand(IntegrateCommand());
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
        print('${Colorize('Running command: $commandName').yellow}');
        print('${Colorize('Arguments: ${commandArgs.join(' ')}').yellow}');
      }

      await command.execute(commandArgs);
    } catch (e) {
      _handleCommandError(commandName, e);
    }
  }

  void _showHelp() {
    print("${Colorize('Available commands:').bold().green}");
    print("");
    if (_commands.isEmpty) {
      print(
        'No commands available. Please check the documentation for available commands.',
      );
      return;
    } else {
      for (final entry in _commands.entries) {
        print("  ${entry.key.padRight(15)} ${entry.value.description}");
      }
    }

    print('');
    print(
      'For detailed help on specific commands, use "flutter_maps_integrate <command> --help"',
    );
  }

  void _showUnknownCommand(String commandName) {
    print('${Colorize('Unknown command: $commandName').red}');
    print('');
    print('Available commands:');
    _showHelp();
  }

  void _handleCommandError(String commandName, dynamic error) {
    print("${Colorize('Error executing command: $commandName : $error').red}");
    if (verbose) {
      print('${Colorize('Stack trace:').yellow}');
      print(error);
    }
  }
}
