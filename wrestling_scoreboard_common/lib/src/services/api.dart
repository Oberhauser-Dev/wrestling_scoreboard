import '../../common.dart';

typedef GetSingleOfOrg = Future<T> Function<T extends Organizational>(String orgSyncId, {required int orgId});
typedef GetMany = Future<List<T>> Function<T extends DataObject, S extends DataObject>(S filterObject);

enum WrestlingApiProvider { deNwRingenApi, deByRingenApi }
