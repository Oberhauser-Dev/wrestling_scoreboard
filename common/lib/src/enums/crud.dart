enum CRUD {
  create,
  read,
  update,
  delete,
}

CRUD crudDecode(String val) {
  return CRUD.values.singleWhere((element) => element.toString() == 'CRUD.' + val);
}

String crudEncode(CRUD val) {
  return val.toString().substring(5);
}