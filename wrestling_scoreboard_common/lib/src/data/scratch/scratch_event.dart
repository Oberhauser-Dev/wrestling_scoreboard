import '../../../common.dart';

class ScratchEvent extends WrestlingEvent {
  @override
  DataObject copyWithId(int? id) {
    return this;
  }

  @override
  int? get id => null;

  @override
  String? get comment => null;

  @override
  DateTime get date => MockableDateTime.now();

  @override
  @override
  String? get location => null;

  @override
  String? get no => null;

  @override
  String? get orgSyncId => null;

  @override
  Organization? get organization => null;

  @override
  String get tableName => 'scratch';

  @override
  Map<String, Object?> toJson() {
    return {};
  }

  @override
  int? get visitorsCount => null;
}
