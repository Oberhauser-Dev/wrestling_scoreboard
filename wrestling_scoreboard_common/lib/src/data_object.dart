import '../common.dart';

typedef GetSingleOfTypeCallback = Future<T> Function<T extends DataObject>(int id);

abstract class DataObject {
  int? get id;

  Map<String, Object?> toJson();

  Map<String, dynamic> toRaw();

  DataObject copyWithId(int? id);

  String get tableName;
}

abstract class Organizational extends DataObject {
  String? get orgSyncId;

  Organization? get organization;
}

abstract class ImageObjectData implements DataObject {
  String? get imageUri;
}

abstract class PosOrderable implements DataObject {
  int get pos;
}

class DataUnimplementedError extends UnimplementedError {
  DataUnimplementedError(CRUD operationType, Type type, [DataObject? filterObject])
    : super(
        'Data ${operationType.toString().substring(5).toUpperCase()}-request for "${type.toString()}" '
        '${filterObject == null ? '' : 'in "${filterObject.runtimeType.toString()}"'} not found.',
      );
}
