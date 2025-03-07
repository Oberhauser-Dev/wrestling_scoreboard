import 'package:collection/collection.dart';

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true' || this == '1';
  }
}

mixin Compare<T> on Comparable<T> {
  bool operator <=(T other) => compareTo(other) <= 0;

  bool operator >=(T other) => compareTo(other) >= 0;

  bool operator <(T other) => compareTo(other) < 0;

  bool operator >(T other) => compareTo(other) > 0;

  @override
  bool operator ==(other) => other is T && compareTo(other as T) == 0;
}

mixin EnumIndexOrdering<T extends Enum> on Enum implements Comparable<T> {
  @override
  int compareTo(T other) => index.compareTo(other.index);

  bool operator <(T other) {
    return index < other.index;
  }

  bool operator >(T other) {
    return index > other.index;
  }

  bool operator >=(T other) {
    return index >= other.index;
  }

  bool operator <=(T other) {
    return index <= other.index;
  }
}

extension ZeroOrOne<T> on Iterable<T> {
  T? get zeroOrOne {
    Iterator<T> it = iterator;
    if (!it.moveNext()) return null;
    T result = it.current;
    if (it.moveNext()) throw StateError('More than one element');
    return result;
  }
}

extension IndexOfLetter on String {
  int? toIndex() {
    if (isEmpty) return null;
    assert(length == 1);
    // Mask bits with 00011111 (0x1f)
    // Big letters 'A', start with 01000001
    // Small letters 'a', start with 01100001
    return codeUnitAt(0) & 0x1f;
  }
}

extension GroupListByIterable<T> on Iterable<T> {
  Map<Iterable<K>, List<T>> groupListsByIterable<K>(Iterable<K> Function(T element) keyOf) {
    var result = <Iterable<K>, List<T>>{};
    for (var element in this) {
      final keyValue = keyOf(element);
      final key = result.keys.firstWhere(
        (tmpKey) => DeepCollectionEquality().equals(tmpKey, keyValue),
        orElse: () => keyValue,
      );
      (result[key] ??= []).add(element);
    }
    return result;
  }
}

extension X<T> on Iterable<T> {
  Iterable<T> intersperse(T separator, {bool beforeFirst = false, bool afterLast = false}) sync* {
    bool empty = true;
    for (var e in this) {
      if (!empty || beforeFirst) yield separator;
      empty = false;
      yield e;
    }
    if (!empty && afterLast) yield separator;
  }
}
