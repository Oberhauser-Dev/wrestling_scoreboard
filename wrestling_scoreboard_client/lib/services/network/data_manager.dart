import 'dart:async';

import 'package:wrestling_scoreboard_client/services/network/remote/web_socket.dart';
import 'package:wrestling_scoreboard_common/common.dart';

/// Data exchange layer with CRUD operations
abstract class DataManager implements AuthManager {
  /// The auth service, if avilable.
  final AuthService? authService;

  DataManager({this.authService});

  /// Only used for delete action. Should actually be a REST statement, or using WebsocketManager directly.
  set webSocketManager(WebSocketManager manager);

  /// READ: get a single object
  Future<T> readSingle<T extends DataObject>(int id);

  /// READ: get many objects
  Future<List<T>> readMany<T extends DataObject, S extends DataObject?>({S? filterObject});

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
  Stream<ManyDataObject<T>> streamMany<T extends DataObject, S extends DataObject?>(
      {S? filterObject, bool init = true}) {
    final controller = getOrCreateManyStreamController<T>(filterType: S);
    var stream = controller.stream;

    if (filterObject != null) {
      stream = stream.where((e) => e.filterId == filterObject.id!);
    }
    if (init) {
      // Use try / catch instead of Future.catchError, because Dart Debugger can't recognize this as uncaught.
      (() async {
        try {
          final many = await readMany<T, S>(filterObject: filterObject);
          controller.sink.add(ManyDataObject<T>(data: many, filterType: S, filterId: filterObject?.id));
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
  Future<Iterable<Map<String, dynamic>>> readManyJson<T extends DataObject, S extends DataObject?>({S? filterObject});

  /// CREATE | UPDATE: create or update a single object
  /// Returns the id of the object
  Future<int> createOrUpdateSingle<T extends DataObject>(T single);

  /// DELETE: delete a single object
  Future<void> deleteSingle<T extends DataObject>(T single);

  /// CREATE: generate bouts of a wrestling event
  /// If [isReset] is true, then delete all previous Bouts and TeamMatchBouts, else reuse the states.
  Future<void> generateBouts<S extends WrestlingEvent>(WrestlingEvent wrestlingEvent, [bool isReset = false]);

  Future<String> exportDatabase();

  Future<void> restoreDatabase(String sqlDump);

  Future<void> restoreDefaultDatabase();

  Future<void> resetDatabase();

  Future<void> organizationImport(int id, {AuthService? authService});

  Future<void> organizationTeamImport(int id, {AuthService? authService});

  Future<void> organizationLeagueImport(int id, {AuthService? authService});

  Future<void> organizationCompetitionImport(int id, {AuthService? authService});

  Future<void> organizationTeamMatchImport(int id, {AuthService? authService});

  Future<DateTime?> organizationLastImportUtcDateTime(int id);

  Future<DateTime?> organizationTeamLastImportUtcDateTime(int id);

  Future<DateTime?> organizationLeagueLastImportUtcDateTime(int id);

  Future<DateTime?> organizationCompetitionLastImportUtcDateTime(int id);

  Future<DateTime?> organizationTeamMatchLastImportUtcDateTime(int id);

  Future<Map<String, List<DataObject>>> search({
    required String searchTerm,
    Type? type,
    int? organizationId,
    AuthService? authService,
    bool includeApiProviderResults = false,
  });

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

  StreamController<ManyDataObject<T>> getOrCreateManyStreamController<T extends DataObject>({Type? filterType = Null}) {
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

abstract class AuthManager {
  Future<String> signIn(BasicAuthService authService);

  Future<void> signUp(User user);

  Future<User?> getUser();

  Future<void> updateUser(User user);
}
