import 'dart:convert';

String rawJsonEncode(Object? object) {
  return json.encode(
    object,
    toEncodable: (item) {
      if (item is DateTime) {
        return item.toIso8601String();
      }
      return item;
    },
  );
}
