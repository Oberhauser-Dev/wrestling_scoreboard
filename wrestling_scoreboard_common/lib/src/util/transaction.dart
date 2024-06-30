import 'dart:async';

Map<String, Completer> _transactionLocks = {};

Future<T> runSynchronized<T>({
  required String key,
  bool Function()? canAbort,
  required Future<T> Function() runAsync,
  Duration timeout = const Duration(seconds: 30),
}) async {
  Completer? completer;
  try {
    completer = await _lockTransaction(key: key, canAbort: canAbort)
        .timeout(timeout, onTimeout: () => throw 'Locking for $key took longer than $timeout.');
    final result =
        await runAsync().timeout(timeout, onTimeout: () => throw 'Async execution for $key took longer than $timeout.');
    completer?.complete();
    return result;
  } catch (error) {
    print(error);
    completer?.completeError(error);
    rethrow;
  } finally {
    _transactionLocks.remove(key);
  }
}

/// Lock transactions, so that they aren't executed at the same time and may can be avoided.
Future<Completer?> _lockTransaction({required String key, bool Function()? canAbort}) async {
  if (canAbort != null && canAbort()) {
    return null;
  }
  while (_transactionLocks.containsKey(key)) {
    await _transactionLocks[key]?.future;
    // Check again after waiting period
    if (canAbort != null && canAbort()) {
      return null;
    }
  }
  final completer = Completer();
  _transactionLocks[key] = completer;
  return completer;
}

Future<T> retry<T>({
  required Future<T> Function() runAsync,
  Duration timeout = const Duration(seconds: 5),
  int attempts = 5,
}) async {
  for (int attempt = 0; attempt < attempts; attempt++) {
    try {
      return await runAsync()
          .timeout(timeout, onTimeout: () => throw 'Async execution took longer than $timeout. Retry ${attempt + 1}');
    } catch (error) {
      print(error);
    }
  }
  throw Exception('Final attempt went wrong.');
}
