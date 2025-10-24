import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrestling_scoreboard_client/models/backup.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';

part 'backup_provider.g.dart';

@Riverpod(dependencies: [BackupEnabledNotifier, BackupRulesNotifier])
class BackupNotifier extends _$BackupNotifier {
  @override
  Raw<Future<(String?, List<BackupRule>)>> build() async {
    final backupEnabled = await ref.watch(backupEnabledProvider);
    final appDataDir = await ref.watch(appDataDirectoryProvider);
    if (!backupEnabled || appDataDir == null) return (null, <BackupRule>[]);

    final backupDir = path.join(appDataDir, 'backups');
    final backupRules = await ref.watch(backupRulesProvider);
    return (backupDir, backupRules);
  }
}
