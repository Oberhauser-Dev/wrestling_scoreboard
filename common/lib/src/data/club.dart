import 'package:json_annotation/json_annotation.dart';

import 'data_object.dart';

part 'club.g.dart';

/// The sports club.
@JsonSerializable()
class Club extends DataObject {
  final String? no; // Vereinsnummer
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
}
