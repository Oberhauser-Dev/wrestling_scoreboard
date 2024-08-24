import '../../common.dart';

enum UserPrivilege with EnumIndexOrdering {
  none,
  read,
  write,
  admin;

  String get name => toString().split('.').last;
}
