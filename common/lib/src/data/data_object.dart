abstract class DataObject {
  int? id;

  DataObject([this.id]);

  @override
  bool operator ==(o) => o is DataObject && o.runtimeType == runtimeType && id == o.id;
}
