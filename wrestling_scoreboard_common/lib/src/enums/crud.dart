enum CRUD {
  create,
  read,
  update,
  delete;

  String get name => toString().split('.').last;
}
