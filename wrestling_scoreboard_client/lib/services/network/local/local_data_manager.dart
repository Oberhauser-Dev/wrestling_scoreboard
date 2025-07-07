import 'package:wrestling_scoreboard_client/mocks/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/local/local_providers.dart';
import 'package:wrestling_scoreboard_common/common.dart';

/// Stores the information given to the local preferences.
// TODO: Extract common functionality of MockDataManager and extend from it, when want to make sure everything works locally.
class LocalDataManager extends MockDataManager {
  final Future<List<Map<String, dynamic>>> Function<T extends DataObject>() getLocalJsonData;
  final LocalDataNotifier<T> Function<T extends DataObject>() getLocalDataNotifier;

  // Store max given id, to avoid duplicates
  static final Map<Type, int> idCounter = {};

  LocalDataManager(this.getLocalDataNotifier, this.getLocalJsonData);

  Future<List<T>> getLocalData<T extends DataObject>() async {
    final jsonList = await getLocalJsonData<T>();
    return await Future.wait(
      jsonList.map(
        (json) => DataObjectParser.fromRaw<T>(json, <E extends DataObject>(int id) async => readSingle<E>(id)),
      ),
    );
  }

  @override
  Future<int> createOrUpdateSingle<T extends DataObject>(T single) async {
    List<T> allMany = await getLocalData<T>();
    (single, allMany) = _handleUpdateSingle<T>(single, allMany);
    await getLocalDataNotifier<T>().setState(allMany);
    broadcastDependants<T>(single);
    return single.id!;
  }

  (T, List<T>) _handleUpdateSingle<T extends DataObject>(T single, List<T> allMany) {
    if (single.id == null) {
      final newId = (idCounter[T] ?? 0) + 1;
      idCounter[T] = newId;
      single = single.copyWithId(newId) as T;
      allMany.add(single);
    } else {
      final index = allMany.indexWhere((element) => element.id == single.id);
      if (index >= 0) {
        allMany[index] = single;
      } else {
        // Add predefined entities, if not yet stored.
        allMany.add(single);
      }
      broadcastSingle<T>(single);
    }
    return (single, allMany);
  }

  @override
  Future<List<T>> createOrUpdateMany<T extends DataObject, S extends DataObject>(
    List<T> many, {
    S? filterObject,
  }) async {
    List<T> allMany = (await getLocalData<T>()).toList();

    // Remove all entities of the same filter
    final filteredMany = await getListOfTypeAndFilter<T>(filterObject: filterObject);
    await Future.wait(
      filteredMany.map((filtered) async => allMany.removeWhere((element) => element.id == filtered.id)),
    );

    for (final single in many) {
      allMany = _handleUpdateSingle<T>(single, allMany).$2;
    }
    await getLocalDataNotifier<T>().setState(allMany);
    return allMany;
  }

  @override
  Future<void> deleteSingle<T extends DataObject>(T single) async {
    final res = (await getLocalData<T>()).toList();
    final index = res.indexWhere((element) => element.id == single.id);
    if (index >= 0) {
      res.removeAt(index);
    }
    await getLocalDataNotifier<T>().setState(res);
    broadcastDependants(single);
  }

  @override
  Future<T> readSingle<T extends DataObject>(int id) async {
    return (await readMany<T, Null>()).singleWhere((element) => element.id == id);
  }

  @override
  Future<List<T>> readMany<T extends DataObject, S extends DataObject?>({S? filterObject}) async {
    return await getListOfTypeAndFilter<T>(filterObject: filterObject);
  }

  @override
  Future<List<T>> getListOfType<T extends DataObject>() async {
    return (await getLocalData<T>()).toList();
  }
}
