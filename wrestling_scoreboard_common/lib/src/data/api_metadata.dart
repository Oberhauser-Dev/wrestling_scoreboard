import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_metadata.freezed.dart';
part 'api_metadata.g.dart';

@freezed
abstract class ApiMetadata with _$ApiMetadata {
  const ApiMetadata._();

  const factory ApiMetadata({required int entityId, required String entityType, DateTime? lastImport}) = _ApiMetadata;

  factory ApiMetadata.fromJson(Map<String, Object?> json) => _$ApiMetadataFromJson(json);

  static Future<ApiMetadata> fromRaw(Map<String, dynamic> e) async {
    return ApiMetadata(
      entityId: e['entity_id'] as int,
      entityType: e['entity_type'] as String,
      lastImport: e['last_import'] as DateTime?,
    );
  }

  Map<String, dynamic> toRaw() {
    return {'entity_id': entityId, 'entity_type': entityType, 'last_import': lastImport};
  }

  static const cTableName = 'api_metadata';
}
