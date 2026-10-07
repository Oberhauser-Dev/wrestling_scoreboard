import 'package:args/command_runner.dart';
import 'package:wrestling_scoreboard_server/services/config_wizard.dart';

class ConfigCommand extends Command<int> {
  @override
  final name = 'config';

  @override
  final description = 'Create or change the config file by answering questions in the terminal.';

  @override
  int run() => runConfigWizard() ? 0 : 1;
}
