import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:wrestling_scoreboard_server/commands/server_command_runner.dart';

Future<void> main(List<String> arguments) async {
  try {
    // Sets the code the process exits with, once the server stopped or failed to start.
    exitCode = await ServerCommandRunner().run(arguments) ?? 0;
  } on UsageException catch (e) {
    stderr.writeln(e);
    exitCode = 64;
  }
  // Terminate on failure, even if e.g. a failed database connection still keeps the process alive.
  if (exitCode != 0) exit(exitCode);
}
