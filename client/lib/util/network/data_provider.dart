import 'dart:async';

import 'package:common/common.dart';
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
  Stream<T> readSingleStream<T extends DataObject>(int id);

  /// READ: get many objects
  Stream<ManyDataObject> readManyStream<T extends DataObject>({DataObject? filterObject}) {
    final filterType = filterObject == null ? Object : filterObject.getBaseType();
    var stream = getOrCreateManyStreamController<T>(filterType: filterType).stream;
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

  final Map<Type, StreamController<DataObject>> _singleStreamControllers = Map<Type, StreamController<DataObject>>();
  final Map<Type, Map<Type, StreamController<ManyDataObject>>> _manyStreamControllers =
      Map<Type, Map<Type, StreamController<ManyDataObject>>>();

  StreamController<T>? getSingleStreamController<T extends DataObject>() {
    return _singleStreamControllers[T] as StreamController<T>?;
  }

  StreamController<T> getOrCreateSingleStreamController<T extends DataObject>() {
    StreamController<T>? streamController = getSingleStreamController<T>();
    if (streamController == null) {
      streamController = StreamController<T>.broadcast();
      _singleStreamControllers[T] = streamController;
    }
    return streamController;
  }

  StreamController<ManyDataObject>? getManyStreamController<T extends DataObject>({Type filterType = Object}) {
    Map<Type, StreamController<ManyDataObject>>? streamControllersOfType = _manyStreamControllers[T];
    return streamControllersOfType == null ? null : streamControllersOfType[filterType];
  }

  StreamController<ManyDataObject> getOrCreateManyStreamController<T extends DataObject>({Type filterType = Object}) {
    var streamController = getManyStreamController<T>(filterType: filterType);
    if (streamController == null) {
      streamController = StreamController<ManyDataObject>.broadcast();
      Map<Type, StreamController<ManyDataObject>>? streamControllersOfType = _manyStreamControllers[T];
      if (streamControllersOfType == null) {
        streamControllersOfType = Map<Type, StreamController<ManyDataObject>>();
        _manyStreamControllers[T] = streamControllersOfType;
      }
      streamControllersOfType[filterType] = streamController;
    }
    return streamController;
  }
}
