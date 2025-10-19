import '../../common.dart';

typedef GetSingleOfOrg = Future<T> Function<T extends Organizational>(String orgSyncId, {required int orgId});
typedef GetMany =
    Future<List<T>> Function<T extends DataObject>({
      List<String>? conditions,
      Map<String, dynamic>? substitutionValues,
    });

enum WrestlingApiProvider { deNwRingenApi, deByRingenApi }
