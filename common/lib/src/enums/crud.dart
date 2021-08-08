enum CRUD {
  create,
  read,
  update,
  delete,
}

extension CrudParser on CRUD {
  String get name => toString().split('.').last;

  static CRUD valueOf(String name) => CRUD.values.singleWhere((element) => element.name == name);
}
