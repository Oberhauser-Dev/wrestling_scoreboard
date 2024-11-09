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
