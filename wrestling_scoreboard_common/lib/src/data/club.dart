import 'package:freezed_annotation/freezed_annotation.dart';

import 'data_object.dart';

part 'club.freezed.dart';
part 'club.g.dart';

/// The sports club.
@freezed
class Club with _$Club implements DataObject {
  const Club._();

  const factory Club({
    int? id,
    required String name,
    String? no, // Club-ID
  }) = _Club;

  factory Club.fromJson(Map<String, Object?> json) => _$ClubFromJson(json);

  @override
  Map<String, dynamic> toRaw() {
    return {
      if (id != null) 'id': id,
      'no': no,
      'name': name,
    };
  }

  static Future<Club> fromRaw(Map<String, dynamic> e) async => Club(
        id: e['id'] as int?,
        no: e['no'] as String?,
        name: e['name'] as String,
      );

  @override
  String get tableName => 'club';

  @override
  Club copyWithId(int? id) {
    return copyWith(id: id);
  }
}
