import '../../common.dart';

enum UserPrivilege with EnumIndexOrdering {
  /// User can see public data only
  none,

  /// User can see all data (with consent)
  read,

  /// User can write all data
  write,

  /// User can edit privileges
  admin,
}
