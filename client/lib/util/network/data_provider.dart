import 'dart:async';

import 'package:common/common.dart';
import 'package:wrestling_scoreboard/data/data_object.dart';
import 'package:wrestling_scoreboard/mocks/mock_data_provider.dart';
import 'package:wrestling_scoreboard/util/network/remote/rest.dart';

import '../environment.dart';

final _isMock = env(appEnvironment, fallBack: 'development') == 'mock';

final dataProvider = _isMock ? MockDataProvider() : RestDataProvider();

/// Data exchange layer with CRUD operations
abstract class DataProvider {
  /// READ: get a single object
  Future<T> readSingle<T extends DataObject>(int id);

  /// READ: get many objects
  Future<Iterable<T>> readMany<T extends DataObject>({DataObject? filterObject});

  /// READ: get a single object
  Stream<T> streamSingle<T extends DataObject>(Type t, int id, {bool init = false});

  /// READ: get many objects
  Stream<ManyDataObject<T>> streamMany<T extends DataObject>(Type t, {DataObject? filterObject, bool init = true}) {
    final filterType = filterObject == null ? Object : filterObject.getBaseType();
    final controller = getOrCreateManyStreamController<T>(t, filterType: filterType);
    if (init) {
      readMany<T>(filterObject: filterObject).then((value) =>
          controller.sink.add(ManyDataObject(data: value, filterType: filterType, filterId: filterObject?.id)));
    }
    var stream = controller.stream;
    if (filterObject != null) {
      stream = stream.where((e) => e.filterId == filterObject.id!);
    }
    return stream;
  }

  /// READ: get a single raw object
  Future<Map<String, dynamic>> readRawSingle<T extends DataObject>(int id);

  /// READ: get many raw objects
  Future<Iterable<Map<String, dynamic>>> readRawMany<T extends DataObject>({DataObject? filterObject});

  /// CREATE | UPDATE: create or update a single object
  Future<void> createOrUpdateSingle(DataObject obj);

  /// DELETE: delete a single object
  Future<void> deleteSingle(DataObject obj);

  /// CREATE: generate fights of a wrestling event
  Future<void> generateFights(WrestlingEvent wrestlingEvent, [bool reset = false]);

  final Map<Type, StreamController<DataObject>> _singleStreamControllers = {};
  final Map<Type, Map<Type, StreamController<ManyDataObject>>> _manyStreamControllers = {};

  StreamController<T>? getSingleStreamController<T extends DataObject>(Type t) {
    return _singleStreamControllers[getBaseType(t)] as StreamController<T>?;
  }

  StreamController<T> getOrCreateSingleStreamController<T extends DataObject>(Type t) {
    StreamController<T>? streamController = getSingleStreamController<T>(t);
    if (streamController == null) {
      streamController = StreamController<T>.broadcast();
      _singleStreamControllers[getBaseType(t)] = streamController;
    }
    return streamController;
  }

  StreamController<ManyDataObject<T>>? getManyStreamController<T extends DataObject>(Type t, {Type filterType = Object}) {
    Map<Type, StreamController<ManyDataObject<T>>>? streamControllersOfType = _manyStreamControllers[getBaseType(t)]?.cast<Type, StreamController<ManyDataObject<T>>>();
    return streamControllersOfType == null ? null : streamControllersOfType[filterType];
  }

  StreamController<ManyDataObject<T>> getOrCreateManyStreamController<T extends DataObject>(Type t, {Type filterType = Object}) {
    var streamController = getManyStreamController<T>(t, filterType: filterType);
    if (streamController == null) {
      streamController = StreamController<ManyDataObject<T>>.broadcast();
      Map<Type, StreamController<ManyDataObject<T>>>? streamControllersOfType = _manyStreamControllers[getBaseType(t)]?.cast<Type, StreamController<ManyDataObject<T>>>();
      if (streamControllersOfType == null) {
        streamControllersOfType = <Type, StreamController<ManyDataObject<T>>>{};
        _manyStreamControllers[getBaseType(t)] = streamControllersOfType;
      }
      streamControllersOfType[filterType] = streamController;
    }
    return streamController;
  }
}
