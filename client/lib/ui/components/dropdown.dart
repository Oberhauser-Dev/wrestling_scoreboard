import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

Widget getDropdown<T>({
  required T? selectedItem,
  required String label,
  void Function(T? value)? onChanged,
  void Function(T? value)? onSaved,
  required Future<List<T>> Function(String? filter) onFind,
  required String Function(T u) itemAsString,
  required BuildContext context,
  Widget? icon,
}) {
  return DropdownSearch<T>(
    dropdownSearchDecoration: InputDecoration(labelText: label, icon: icon),
    searchFieldProps: TextFieldProps(decoration: const InputDecoration(prefixIcon: Icon(Icons.search))),
    mode: Mode.MENU,
    showSearchBox: true,
    showClearButton: true,
    onFind: (String? filter) => onFind(filter),
    itemAsString: (T? u) => u != null ? itemAsString(u) : 'empty value',
    selectedItem: selectedItem,
    onChanged: onChanged,
    onSaved: onSaved,
  );
}
