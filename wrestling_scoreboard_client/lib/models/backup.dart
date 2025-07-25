import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup.freezed.dart';
part 'backup.g.dart';

@freezed
abstract class BackupRule with _$BackupRule {
  const BackupRule._();

  const factory BackupRule({required String name, required Duration period, required Duration deleteAfter}) =
      _BackupRule;

  factory BackupRule.fromJson(Map<String, Object?> json) => _$BackupRuleFromJson(json);

  static final defaultBackupRules = [
    BackupRule(name: 'recently', period: Duration(minutes: 5), deleteAfter: Duration(hours: 1)),
    BackupRule(name: 'hourly', period: Duration(hours: 1), deleteAfter: Duration(days: 1)),
    BackupRule(name: 'daily', period: Duration(days: 1), deleteAfter: Duration(days: 7)),
    BackupRule(name: 'weekly', period: Duration(days: 7), deleteAfter: Duration(days: 28)),
    BackupRule(name: 'monthly', period: Duration(days: 28), deleteAfter: Duration(days: 365)),
  ];
}
