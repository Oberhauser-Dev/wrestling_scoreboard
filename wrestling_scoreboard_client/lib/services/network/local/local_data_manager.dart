import 'dart:math' as math;

import 'package:logging/logging.dart' show Logger;
import 'package:wrestling_scoreboard_client/mocks/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/local/local_providers.dart';
import 'package:wrestling_scoreboard_common/common.dart';

final _logger = Logger('LocalDataManager');

/// Default scratch bout objects
final organization = Organization(id: 0, name: 'Organization');
final person0 = Person(id: 0, prename: 'Red', surname: '');
final person1 = Person(id: 1, prename: 'Blue', surname: '');
final club0 = Club(id: 0, organization: organization, name: 'Home');
final club1 = Club(id: 1, organization: organization, name: 'Guest');
final membership0 = Membership(id: 0, club: club0, person: person0);
final membership1 = Membership(id: 1, club: club1, person: person1);
final athleteBoutState0 = AthleteBoutState(id: 0, membership: membership0);
final athleteBoutState1 = AthleteBoutState(id: 1, membership: membership1);
final bout = Bout(id: 0, r: athleteBoutState0, b: athleteBoutState1);
final weightClassFree = WeightClass(id: 0, weight: 0, style: WrestlingStyle.free);
final weightClassGreco = WeightClass(id: 1, weight: 0, style: WrestlingStyle.greco);
final boutConfig = Competition.defaultBoutConfig.copyWithId(0);
final boutResultRules =
    Competition.defaultBoutResultRules.indexed.map((e) => e.$2.copyWith(id: e.$1, boutConfig: boutConfig)).toList();
final scratchBout = ScratchBout(id: 0, bout: bout, boutConfig: boutConfig, weightClass: weightClassFree);

/// Stores the information given to the local preferences.
// TODO: Extract common functionality of MockDataManager and extend from it, when want to make sure everything works locally.
class LocalDataManager extends MockDataManager {
  final Future<List<Map<String, dynamic>>> Function<T extends DataObject>() getLocalJsonData;
  final LocalDataNotifier<T> Function<T extends DataObject>() getLocalDataNotifier;

  // Store max given id, to avoid duplicates
  static final Map<Type, int> idCounter = {};

  LocalDataManager(this.getLocalDataNotifier, this.getLocalJsonData);

  static List<T> _createDefaultEntities<T extends DataObject>(List<T> result) {
    // Provide a set of default entities to create a scratch bout
    return switch (T) {
      const (Bout) => [bout as T],
      const (Organization) => [organization as T],
      const (AthleteBoutState) => [athleteBoutState0 as T, athleteBoutState1 as T],
      const (Membership) => [membership0 as T, membership1 as T],
      const (Club) => [club0 as T, club1 as T],
      const (Person) => [person0 as T, person1 as T],
      const (BoutConfig) => [boutConfig as T],
      // Only add Bout Result Rule, if empty, otherwise it would add random rules which the user does not expect
      const (BoutResultRule) => result.isEmpty ? boutResultRules.cast<T>() : [],
      const (WeightClass) => [weightClassFree as T, weightClassGreco as T],
      const (ScratchBout) => [scratchBout as T],
      _ => [],
    };
  }

  Future<List<T>> _fromRaw<T extends DataObject>(Iterable<Map<String, dynamic>> jsonList) async {
    return (await Future.wait(
      jsonList.map((json) async {
        try {
          return await DataObjectParser.fromRaw<T>(json, <E extends DataObject>(int id) async => readSingle<E>(id));
        } catch (e, st) {
          // Catch if parsing fails, e.g. when mandatory fields were added.
          _logger.warning('Could not parse local json: \n$json', e, st);
          return null;
        }
      }),
    )).nonNulls.toList(growable: true);
  }

  Future<List<T>> getLocalData<T extends DataObject>() async {
    final jsonList = await getLocalJsonData<T>();
    final result = await _fromRaw<T>(jsonList);

    // Add default entities, if not present yet.
    final defaultEntities = _createDefaultEntities<T>(result);
    final diff = defaultEntities.map((e) => e.id).toSet().difference(result.map((e) => e.id).toSet());
    if (diff.isNotEmpty) {
      // Always add default entities which were not saved yet.
      final diffEntities = diff.map((id) => defaultEntities.singleWhere((e) => e.id == id));
      // Purposely convert to raw and back to entity to retrieve the current property dependencies
      final rawDiffEntities = diffEntities.map((e) => e.toRaw());
      result.addAll(await _fromRaw<T>(rawDiffEntities));
    }
    idCounter[T] = result.fold(idCounter[T] ?? 0, (value, element) => math.max(value, element.id ?? 0));
    return result;
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
