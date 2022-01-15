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
  Future<S> readSingle<T extends DataObject, S extends T>(int id);

  /// READ: get many objects
  Future<List<S>> readMany<T extends DataObject, S extends T>({DataObject? filterObject});

  /// READ: get a single object
  Stream<S> streamSingle<T extends DataObject, S extends T>(int id, {bool init = false}) {
    final controller = getOrCreateSingleStreamController<T, S>();
    if(init) readSingle<T, S>(id).then((value) => controller.sink.add(value));
    return controller.stream.where((event) => event.id == id);
  }

  /// READ: get many objects
  Stream<ManyDataObject<S>> streamMany<T extends DataObject, S extends T>({DataObject? filterObject, bool init = true}) {
    final filterType = filterObject == null ? Object : filterObject.getBaseType();
    final controller = getOrCreateManyStreamController<T, S>(filterType: filterType);
    var stream = controller.stream;
    if (filterObject != null) {
      stream = stream.where((e) => e.filterId == filterObject.id!);
    }
    if (init) {
      readMany<T, S>(filterObject: filterObject).then((value) =>
          controller.sink.add(ManyDataObject(data: value, filterType: filterType, filterId: filterObject?.id)));
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

  StreamController<S>? getSingleStreamController<T extends DataObject, S extends T>() {
    return _singleStreamControllers[T] as StreamController<S>?;
  }

  StreamController<S> getOrCreateSingleStreamController<T extends DataObject, S extends T>() {
    StreamController<S>? streamController = getSingleStreamController<T, S>();
    if (streamController == null) {
      streamController = StreamController<S>.broadcast();
      _singleStreamControllers[T] = streamController;
    }
    return streamController;
  }

  StreamController<ManyDataObject<S>>? getManyStreamController<T extends DataObject, S extends T>({Type filterType = Object}) {
    Map<Type, StreamController<ManyDataObject<S>>>? streamControllersOfType = _manyStreamControllers[T]?.cast<Type, StreamController<ManyDataObject<S>>>();
    return streamControllersOfType == null ? null : streamControllersOfType[filterType];
  }

  StreamController<ManyDataObject<S>> getOrCreateManyStreamController<T extends DataObject, S extends T>({Type filterType = Object}) {
    var streamController = getManyStreamController<T, S>(filterType: filterType);
    if (streamController == null) {
      streamController = StreamController<ManyDataObject<S>>.broadcast();
      Map<Type, StreamController<ManyDataObject<T>>>? streamControllersOfType = _manyStreamControllers[T]?.cast<Type, StreamController<ManyDataObject<S>>>();
      if (streamControllersOfType == null) {
        streamControllersOfType = <Type, StreamController<ManyDataObject<T>>>{};
        _manyStreamControllers[T] = streamControllersOfType;
      }
      streamControllersOfType[filterType] = streamController;
    }
    return streamController;
  }
}
