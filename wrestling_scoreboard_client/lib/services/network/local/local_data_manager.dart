import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/mocks/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/local/local_providers.dart';
import 'package:wrestling_scoreboard_common/common.dart';

/// Stores the information given to the local preferences.
// TODO: Extract common functionality of MockDataManager and extend from it, when want to make sure everything works locally.
class LocalDataManager extends MockDataManager {
  final Ref ref;

  // Store max given id, to avoid duplicates
  static final Map<Type, int> idCounter = {};

  LocalDataManager(this.ref);

  @override
  Future<int> createOrUpdateSingle<T extends DataObject>(T single) async {
    final res = (await ref.read(localDataNotifierProvider<T>())).toList();
    if (single.id == null) {
      final newId = (idCounter[T] ?? 0) + 1;
      idCounter[T] = newId;
      single = single.copyWithId(newId) as T;
      res.add(single);
    } else {
      final index = res.indexWhere((element) => element.id == single.id);
      if (index >= 0) {
        res[index] = single;
      } else {
        // Add predefined entities, if not yet stored.
        res.add(single);
      }
      broadcastSingle<T>(single);
    }
    await ref.read(localDataNotifierProvider<T>().notifier).setState(res);
    broadcastDependants<T>(single);
    return single.id!;
  }

  @override
  Future<void> deleteSingle<T extends DataObject>(T single) async {
    final res = (await ref.read(localDataNotifierProvider<T>())).toList();
    final index = res.indexWhere((element) => element.id == single.id);
    if (index >= 0) {
      res.removeAt(index);
    }
    await ref.read(localDataNotifierProvider<T>().notifier).setState(res);
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
    return (await ref.read(localDataNotifierProvider<T>())).toList();
  }
}
