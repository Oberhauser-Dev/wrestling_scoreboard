import 'package:wrestling_scoreboard/data/club.dart';

// String serialize<T>(T obj) {
//   switch (T) {
//     case Club:
//       return Club.fromJson(json) as T;
//     default:
//       throw UnimplementedError('Cannot deserialize ${T.toString()}');
//   }
// }

T deserialize<T>(Map<String, dynamic> json) {
  switch (T) {
    case Club:
      return Club.fromJson(json) as T;
    default:
      throw UnimplementedError('Cannot deserialize ${T.toString()}');
  }
}
