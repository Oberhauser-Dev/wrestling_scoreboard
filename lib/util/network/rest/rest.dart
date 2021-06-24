import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wrestling_scoreboard/data/club.dart';
import 'package:wrestling_scoreboard/util/serialize.dart';

const apiUrl = 'http://localhost:8080/api';

String _getPathFromClass<T>() {
  switch (T) {
    case Club:
      return '/clubs';
    default:
      throw UnimplementedError('Path for ${T.toString()} not found');
  }
}

Future<T> fetchSingle<T>(String id) async {
  final response = await http.get(Uri.parse('$apiUrl${_getPathFromClass()}/$id'));

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    return deserialize<T>(json);
  } else {
    throw Exception('Failed to load single ${T.toString()}');
  }
}

Future<List<T>> fetchMany<T>() async {
  final response = await http.get(Uri.parse('$apiUrl${_getPathFromClass()}'));

  if (response.statusCode == 200) {
    List json = jsonDecode(response.body);
    return json.map((e) => deserialize<T>(e)).toList();
  } else {
    throw Exception('Failed to load many ${T.toString()}');
  }
}
