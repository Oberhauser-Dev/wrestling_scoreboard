import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:wrestling_scoreboard_server/commands/config_command.dart';
import 'package:wrestling_scoreboard_server/server.dart' as server;
import 'package:wrestling_scoreboard_server/services/config_wizard.dart';
import 'package:wrestling_scoreboard_server/services/environment.dart';
import 'package:wrestling_scoreboard_server/services/startup_check.dart';

/// Command line interface of the server, which returns the exit code of the executed command.
///
/// Without a command, the configuration is checked and the server is started.
class ServerCommandRunner extends CommandRunner<int> {
  ServerCommandRunner()
    : super(
        'wrestling-scoreboard-server',
        'Server for a wrestling scoreboard.\n'
            'Checks the configuration and starts the server, if no command is given.',
      ) {
    argParser.addOption(
      'config-file',
      valueHelp: 'path',
      help:
          'Config file, which overrides the bundled `.env` file '
          '(default: \$$configFileEnvVar or "$defaultConfigFilePath").',
    );
    addCommand(ConfigCommand());
  }

  @override
  String get invocation => '$executableName [<command>] [arguments]';

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    configFileOverride = topLevelResults.option('config-file');
    // Unknown commands end up in `rest`, so they are left to the runner as well as `--help`.
    if (topLevelResults.command == null && topLevelResults.rest.isEmpty && !topLevelResults.flag('help')) {
      if (existingConfigFiles.isEmpty && isInteractiveTerminal) {
        stdout.writeln('No config file found, creating "$configFilePath".');
        if (!runConfigWizard()) return 1;
      }
      server.initLogging();
      if (!await runStartupChecks()) {
        stderr.writeln(
          'Server could not be started, fix the errors above, '
          'e.g. by changing the configuration via `$executableName config`.',
        );
        return 1;
      }
      await server.init();
      return 0;
    } else {
      return super.runCommand(topLevelResults);
    }
  }
}
