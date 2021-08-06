import 'dart:async';

import 'package:common/common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wrestling_scoreboard/mocks/mock_data_provider.dart';
import 'package:wrestling_scoreboard/util/network/remote/rest.dart';

final _isMock = dotenv.env['APP_ENVIRONMENT'] == 'mock';

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
  Stream<Iterable<T>> readManyStream<T extends DataObject>({DataObject? filterObject});

  /// READ: get a single raw object
  Future<Map<String, dynamic>> readRawSingle<T extends DataObject>(int id);

  /// READ: get many raw objects
  Future<Iterable<Map<String, dynamic>>> readRawMany<T extends DataObject>({DataObject? filterObject});

  /// CREATE | UPDATE: create or update a single object
  Future<int> createOrUpdateSingle(DataObject obj);

  /// DELETE: delete a single object
  Future<void> deleteSingle(DataObject obj);

  /// CREATE: generate fights of a wrestling event
  Future<void> generateFights(WrestlingEvent wrestlingEvent, [bool reset = false]);

  final Map<Type, StreamController<DataObject>> _singleStreamControllers = Map<Type, StreamController<DataObject>>();
  final Map<Type, Map<Type, StreamController<Iterable<DataObject>>>> _manyStreamControllers =
      Map<Type, Map<Type, StreamController<Iterable<DataObject>>>>();

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

  StreamController<Iterable<T>>? getManyStreamController<T extends DataObject>({Type filterType = Object}) {
    Map<Type, StreamController<Iterable<T>>>? streamControllersOfType =
        _manyStreamControllers[T] as Map<Type, StreamController<Iterable<T>>>?;
    return streamControllersOfType == null ? null : streamControllersOfType[filterType];
  }

  StreamController<Iterable<T>> getOrCreateManyStreamController<T extends DataObject>({Type filterType = Object}) {
    var streamController = getManyStreamController<T>(filterType: filterType);
    if (streamController == null) {
      streamController = StreamController<Iterable<T>>.broadcast();
      Map<Type, StreamController<Iterable<T>>>? streamControllersOfType =
          _manyStreamControllers[T] as Map<Type, StreamController<Iterable<T>>>?;
      if (streamControllersOfType == null) {
        streamControllersOfType = Map<Type, StreamController<Iterable<T>>>();
        _manyStreamControllers[T] = streamControllersOfType;
      }
      streamControllersOfType[filterType] = streamController;
    }
    return streamController;
  }
}

class DataUnimplementedError extends UnimplementedError {
  DataUnimplementedError(CRUD operationType, Type type, [DataObject? filterObject])
      : super(
            'Data ${operationType.toString().substring(5).toUpperCase()}-request for "${type.toString()}" ${filterObject == null ? '' : 'in "${filterObject.runtimeType.toString()}'}" not found.');
}
