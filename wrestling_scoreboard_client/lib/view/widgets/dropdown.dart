import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';

class SearchableDropdown<T> extends StatelessWidget {
  final T? selectedItem;
  final String label;
  final void Function(T? value)? onChanged;
  final void Function(T? value)? onSaved;
  final Future<List<T>> Function(String filter) asyncItems;
  final bool Function(T item, String filter)? onFilter;
  final String Function(T u) itemAsString;
  final bool allowEmpty;
  final BuildContext context;
  final Widget? icon;
  final bool disableFilter;
  final PopupBuilder<String>? containerBuilder;

  const SearchableDropdown({
    required this.selectedItem,
    required this.label,
    this.onChanged,
    this.onSaved,
    required this.asyncItems,
    this.onFilter,
    required this.itemAsString,
    this.allowEmpty = true,
    required this.context,
    this.icon,
    this.disableFilter = false,
    super.key,
    this.containerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(labelText: label, icon: icon),
      ),
      popupProps: PopupProps.menu(
        searchFieldProps: const TextFieldProps(decoration: InputDecoration(prefixIcon: Icon(Icons.search))),
        showSearchBox: true,
        disableFilter: disableFilter,
        containerBuilder: containerBuilder,
      ),
      suffixProps: DropdownSuffixProps(
        clearButtonProps: const ClearButtonProps(isVisible: true),
      ),
      compareFn: (item1, item2) => itemAsString(item1).compareTo(itemAsString(item2)) >= 0,
      items: (filter, _) => asyncItems(filter),
      filterFn: onFilter,
      itemAsString: (T? u) => u != null ? itemAsString(u) : 'empty value',
      selectedItem: selectedItem,
      onChanged: onChanged,
      validator: (val) => (val == null && !allowEmpty) ? 'This field is mandatory' : null,
      onSaved: onSaved,
    );
  }
}

class SimpleDropdown<T> extends StatelessWidget {
  final Iterable<MapEntry<T, Widget>> options;
  final T? selected;
  final void Function(T? value) onChange;
  final bool isExpanded;
  final bool isNullable;
  final String? hint;
  final AlignmentGeometry alignment;

  const SimpleDropdown({
    required this.options,
    required this.selected,
    required this.onChange,
    this.isNullable = false,
    this.isExpanded = true,
    super.key,
    this.hint,
    this.alignment = AlignmentDirectional.centerStart,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<T>(
      hint: hint,
      isExpanded: isExpanded,
      selected: selected,
      onChange: onChange,
      options: options.map<DropdownMenuItem<T>>(
        (entry) => DropdownMenuItem<T>(
          value: entry.key,
          child: entry.value,
        ),
      ),
      alignment: alignment,
      isNullable: isNullable,
    );
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final Iterable<DropdownMenuItem<T>> options;
  final T? selected;
  final void Function(T? value) onChange;
  final bool isExpanded;
  final bool isNullable;
  final String? hint;
  final AlignmentGeometry alignment;

  const CustomDropdown({
    required this.options,
    required this.selected,
    required this.onChange,
    this.isNullable = false,
    this.isExpanded = true,
    super.key,
    this.hint,
    this.alignment = AlignmentDirectional.centerStart,
  });

  @override
  Widget build(BuildContext context) {
    final items = options.toList();
    if (isNullable) {
      items.add(DropdownMenuItem<T>(
        value: null,
        child: Text(context.l10n.optionSelect, style: TextStyle(color: Theme.of(context).disabledColor)),
      ));
    }
    return DropdownButton<T>(
      hint: hint == null ? null : Text(hint!),
      isExpanded: isExpanded,
      value: selected,
      onChanged: onChange,
      items: items,
      alignment: alignment,
    );
  }
}
