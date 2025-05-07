import 'package:freezed_annotation/freezed_annotation.dart';

part 'migration.freezed.dart';
part 'migration.g.dart';

@freezed
abstract class Migration with _$Migration {
  const Migration._();

  const factory Migration({
    required String semver,
    required String minClientVersion,
  }) = _Migration;

  factory Migration.fromJson(Map<String, Object?> json) => _$MigrationFromJson(json);

  static Future<Migration> fromRaw(Map<String, dynamic> e) async => Migration(
        semver: e['semver'] as String,
        minClientVersion: e['min_client_version'] as String,
      );

  Map<String, dynamic> toRaw() {
    return {
      'semver': semver,
      'min_client_version': minClientVersion,
    };
  }

  static const cTableName = 'migration';
}
