import 'dart:async';

/// In contrast to [map], this is executed synchronously.
/// In contrast to [Future.forEach], this can return the result.
Future<List<T>> forEachFuture<E, T>(Iterable<E> elements, Future<T> Function(E element) action) async {
  var iterator = elements.iterator;
  final resultList = <T>[];
  while (iterator.moveNext()) {
    resultList.add(await action(iterator.current));
  }
  return resultList;
}
