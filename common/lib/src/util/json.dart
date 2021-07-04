import 'dart:convert';

String betterJsonEncode(Object? object) {
  return json.encode(object, toEncodable: (item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  });
}
