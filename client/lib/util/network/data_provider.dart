import 'package:common/common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wrestling_scoreboard/mocks/mock_data_provider.dart';
import 'package:wrestling_scoreboard/util/network/rest/rest.dart';

final _isMock = dotenv.env['APP_ENVIRONMENT'] == 'mock';

final dataProvider = _isMock ? MockDataProvider() : RestDataProvider();

enum CRUD {
  create,
  read,
  update,
  delete,
}

/// Data exchange layer with CRUD operations
abstract class DataProvider {
  /// READ: get a single object
  Future<T> fetchSingle<T extends DataObject>(int id, {DataObject? filterObject});

  /// READ: get many objects
  Future<List<T>> fetchMany<T extends DataObject>({DataObject? filterObject});

  /// CREATE | UPDATE: create or update a single object
  Future<int> createOrUpdateSingle(DataObject obj);

  /// DELETE: delete a single object
  Future<void> deleteSingle(DataObject obj);

  /// CREATE: generate fights of a wrestling event
  Future<void> generateFights(WrestlingEvent wrestlingEvent, [bool reset = false]);
}

class DataUnimplementedError extends UnimplementedError {
  DataUnimplementedError(CRUD operationType, Type type, [DataObject? filterObject])
      : super(
            'Data ${operationType.toString().substring(4).toUpperCase()}-request for "${type.toString()}" ${filterObject == null ? '' : 'in "${filterObject.runtimeType.toString()}'}" not found.');
}
