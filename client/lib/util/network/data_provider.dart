import 'dart:async';

import 'package:common/common.dart';
import 'package:wrestling_scoreboard/mocks/mock_data_provider.dart';
import 'package:wrestling_scoreboard/util/network/remote/rest.dart';

import '../environment.dart';

final _isMock = env(appEnvironment) == 'mock';

final dataProvider = _isMock ? MockDataProvider() : RestDataProvider();

/// Data exchange layer with CRUD operations
abstract class DataProvider {
  /// READ: get a single object
  Future<T> readSingle<T extends DataObject>(int id);

  /// READ: get many objects
  Future<List<T>> readMany<T extends DataObject>({DataObject? filterObject});

  /// READ: get a single object
  Stream<T> streamSingle<T extends DataObject>(int id, {bool init = false}) {
    final controller = getOrCreateSingleStreamController<T>();
    if (init) {
      // Use try / catch instead of Future.catchError, because Dart Debugger can't recognize this as uncaught.
      (() async {
        try {
          final single = await readSingle<T>(id);
          controller.sink.add(single);
        } catch (e) {
          controller.sink.addError(e);
        }
      })();
    }
    return controller.stream.where((event) => event.id == id);
  }

  /// READ: get many objects
  Stream<ManyDataObject<T>> streamMany<T extends DataObject>({DataObject? filterObject, bool init = true}) {
    final controller = getOrCreateManyStreamController<T>(filterType: filterObject.runtimeType);
    var stream = controller.stream;

    if (filterObject != null) {
      stream = stream.where((e) => e.filterId == filterObject.id!);
    }
    if (init) {
      // Use try / catch instead of Future.catchError, because Dart Debugger can't recognize this as uncaught.
      (() async {
        try {
          final many = await readMany<T>(filterObject: filterObject);
          controller.sink
              .add(ManyDataObject<T>(data: many, filterType: filterObject.runtimeType, filterId: filterObject?.id));
        } catch (e) {
          controller.sink.addError(e);
        }
      })();
    }
    return stream;
  }

  /// READ: get a single json object
  Future<Map<String, dynamic>> readSingleJson<T extends DataObject>(int id);

  /// READ: get many json objects
  Future<Iterable<Map<String, dynamic>>> readManyJson<T extends DataObject>({DataObject? filterObject});

  /// CREATE | UPDATE: create or update a single object
  /// Returns the id of the object
  Future<int> createOrUpdateSingle(DataObject single);

  /// DELETE: delete a single object
  Future<void> deleteSingle(DataObject single);

  /// CREATE: generate fights of a wrestling event
  /// If [isReset] is true, then delete all previous Fights and TeamMatchFights, else reuse the states.
  Future<void> generateFights(WrestlingEvent wrestlingEvent, [bool isReset = false]);

  final Map<Type, StreamController<DataObject>> _singleStreamControllers = {};
  final Map<Type, Map<Type, StreamController<ManyDataObject<dynamic>>>> _manyStreamControllers = {};
  final Map<Type, StreamController<Map<String, dynamic>>> _singleRawStreamControllers = {};
  final Map<Type, Map<Type, StreamController<ManyDataObject<Map<String, dynamic>>>>> _manyRawStreamControllers = {};

  StreamController<T>? getSingleStreamController<T extends DataObject>() {
    return _singleStreamControllers[T] as StreamController<T>?;
  }

  StreamController<Map<String, dynamic>>? getSingleRawStreamController<T extends DataObject>() {
    return _singleRawStreamControllers[T];
  }

  StreamController<T> getOrCreateSingleStreamController<T extends DataObject>() {
    StreamController<T>? streamController = getSingleStreamController<T>();
    if (streamController == null) {
      streamController = StreamController<T>.broadcast();
      _singleStreamControllers[T] = streamController;
    }
    return streamController;
  }

  StreamController<Map<String, dynamic>> getOrCreateSingleRawStreamController<T extends DataObject>() {
    StreamController<Map<String, dynamic>>? streamController = getSingleRawStreamController<T>();
    if (streamController == null) {
      streamController = StreamController<Map<String, dynamic>>.broadcast();
      _singleRawStreamControllers[T] = streamController;
    }
    return streamController;
  }

  StreamController<ManyDataObject<T>>? getManyStreamController<T extends DataObject>({Type? filterType = Null}) {
    filterType ??= Null;
    Map<Type, StreamController<ManyDataObject<T>>>? streamControllersOfType =
        _manyStreamControllers[T]?.cast<Type, StreamController<ManyDataObject<T>>>();
    return streamControllersOfType == null ? null : streamControllersOfType[filterType];
  }

  StreamController<ManyDataObject<Map<String, dynamic>>>? getManyRawStreamController<T extends DataObject>(
      {Type? filterType = Null}) {
    filterType ??= Null;
    Map<Type, StreamController<ManyDataObject<Map<String, dynamic>>>>? streamControllersOfType =
        _manyRawStreamControllers[T]?.cast<Type, StreamController<ManyDataObject<Map<String, dynamic>>>>();
    return streamControllersOfType == null ? null : streamControllersOfType[filterType];
  }

  StreamController<ManyDataObject<T>> getOrCreateManyStreamController<T extends DataObject>(
      {Type? filterType = Null}) {
    filterType ??= Null;
    var streamController = getManyStreamController<T>(filterType: filterType);
    if (streamController == null) {
      streamController = StreamController<ManyDataObject<T>>.broadcast();
      Map<Type, StreamController<ManyDataObject<T>>>? streamControllersOfType =
          _manyStreamControllers[T]?.cast<Type, StreamController<ManyDataObject<T>>>();
      if (streamControllersOfType == null) {
        streamControllersOfType = <Type, StreamController<ManyDataObject<T>>>{};
        _manyStreamControllers[T] = streamControllersOfType;
      }
      streamControllersOfType[filterType] = streamController;
    }
    return streamController;
  }

  StreamController<ManyDataObject<Map<String, dynamic>>> getOrCreateManyRawStreamController<T extends DataObject>(
      {Type? filterType = Null}) {
    filterType ??= Null;
    var streamController = getManyRawStreamController<T>(filterType: filterType);
    if (streamController == null) {
      streamController = StreamController<ManyDataObject<Map<String, dynamic>>>.broadcast();
      Map<Type, StreamController<ManyDataObject<Map<String, dynamic>>>>? streamControllersOfType =
          _manyRawStreamControllers[T]?.cast<Type, StreamController<ManyDataObject<Map<String, dynamic>>>>();
      if (streamControllersOfType == null) {
        streamControllersOfType = <Type, StreamController<ManyDataObject<Map<String, dynamic>>>>{};
        _manyRawStreamControllers[T] = streamControllersOfType;
      }
      streamControllersOfType[filterType] = streamController;
    }
    return streamController;
  }
}
