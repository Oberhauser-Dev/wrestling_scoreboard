import 'package:json_annotation/json_annotation.dart';

import 'data_object.dart';

part 'club.g.dart';

/// The sports club.
@JsonSerializable()
class Club extends DataObject {
  /// Club-ID
  final String? no;

  final String name;

  Club({int? id, required this.name, this.no}) : super(id);

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ClubToJson(this);

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
}
