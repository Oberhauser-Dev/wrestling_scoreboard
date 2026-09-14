import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';

/// A [FormField] that lets the user pick an item of type [T] from a list, which is (re-)loaded
/// asynchronously whenever the user types into the search field inside the popup menu.
///
/// The search field lives inside the popup, separate from the field that keeps showing the
/// current selection - so searching for a new value never requires deleting the current
/// selection's text first.
class SearchableDropdown<T> extends FormField<T> {
  SearchableDropdown({
    required T? selectedItem,
    String? label,
    void Function(T? value)? onChanged,
    super.onSaved,
    required Future<List<T>> Function(String filter) asyncItems,
    bool Function(T item, String filter)? onFilter,
    required String Function(T u) itemAsString,
    bool allowEmpty = true,
    required BuildContext context,
    Widget? icon,
    bool disableFilter = false,
    Widget Function(BuildContext context, Widget popupWidget)? containerBuilder,
    super.key,
  }) : super(
         initialValue: selectedItem,
         validator: (value) => (value == null && !allowEmpty) ? context.l10n.mandatoryField : null,
         builder: (FormFieldState<T?> state) {
           return _SearchableDropdownField<T>(
             selectedItem: selectedItem,
             label: label,
             icon: icon,
             allowEmpty: allowEmpty,
             disableFilter: disableFilter,
             asyncItems: asyncItems,
             onFilter: onFilter,
             itemAsString: itemAsString,
             errorText: state.errorText,
             containerBuilder: containerBuilder,
             onChanged: (value) {
               state.didChange(value);
               onChanged?.call(value);
             },
           );
         },
       );
}

class _SearchableDropdownField<T> extends StatefulWidget {
  final T? selectedItem;
  final String? label;
  final Widget? icon;
  final bool allowEmpty;
  final bool disableFilter;
  final Future<List<T>> Function(String filter) asyncItems;
  final bool Function(T item, String filter)? onFilter;
  final String Function(T u) itemAsString;
  final String? errorText;
  final Widget Function(BuildContext context, Widget popupWidget)? containerBuilder;
  final ValueChanged<T?> onChanged;

  const _SearchableDropdownField({
    required this.selectedItem,
    this.label,
    this.icon,
    required this.allowEmpty,
    required this.disableFilter,
    required this.asyncItems,
    this.onFilter,
    required this.itemAsString,
    this.errorText,
    this.containerBuilder,
    required this.onChanged,
  });

  @override
  State<_SearchableDropdownField<T>> createState() => _SearchableDropdownFieldState<T>();
}

class _SearchableDropdownFieldState<T> extends State<_SearchableDropdownField<T>> {
  static const double _menuMaxHeight = 320;

  final MenuController _menuController = MenuController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late T? _selected = widget.selectedItem;
  List<T> _items = [];
  bool _loading = false;

  /// Ensures, only the newest request is displayed.
  int _requestToken = 0;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant _SearchableDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      setState(() => _selected = widget.selectedItem);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _labelFor(T? item) => item == null ? '' : widget.itemAsString(item);

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _loadItems(_searchController.text));
  }

  Future<void> _loadItems(String filter) async {
    final token = ++_requestToken;
    setState(() => _loading = true);
    List<T> items;
    try {
      items = await widget.asyncItems(filter);
    } catch (_) {
      items = [];
    }
    if (widget.onFilter != null) {
      items = items.where((item) => widget.onFilter!(item, filter)).toList();
    } else if (!widget.disableFilter && filter.trim().isNotEmpty) {
      final normalizedFilter = filter.trim().toLowerCase();
      items = items.where((item) => widget.itemAsString(item).toLowerCase().contains(normalizedFilter)).toList();
    }
    items.sort((a, b) => widget.itemAsString(a).compareTo(widget.itemAsString(b)));
    if (!mounted || token != _requestToken) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  void _onOpen() {
    // Always start with a fresh, unfiltered search, regardless of what was typed last time.
    _searchController.clear();
    _loadItems('');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _select(T? value) {
    _debounce?.cancel();
    setState(() => _selected = value);
    widget.onChanged(value);
    _menuController.close();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    // Read the available width up front, so the popup can be sized to match the field instead of
    // shrinking to its narrowest content.
    return LayoutBuilder(
      builder: (context, constraints) {
        final menuWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0;
        // Build the search field + list first, so [containerBuilder] can wrap it with extra content
        // (e.g. a warning banner) that is displayed inside the popup, above or below it.
        Widget popup = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
              ),
            ),
            if (_loading) const LinearProgressIndicator(minHeight: 2),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: _menuMaxHeight),
              // A plain (non-lazy) list in a SingleChildScrollView instead of a ListView: a
              // ListView's viewport can't report intrinsic dimensions, which MenuAnchor needs
              // to size and animate the popup, and would throw as soon as the menu opens.
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final item in _items)
                      ListTile(
                        title: Text(widget.itemAsString(item)),
                        selected: item == _selected,
                        onTap: () => _select(item),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
        if (widget.containerBuilder != null) {
          popup = widget.containerBuilder!(context, popup);
        }
        return MenuAnchor(
          controller: _menuController,
          consumeOutsideTap: true,
          onOpen: _onOpen,
          menuChildren: [SizedBox(width: menuWidth, child: popup)],
          builder: (context, controller, child) {
            return InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: () => controller.isOpen ? controller.close() : controller.open(),
              child: InputDecorator(
                decoration: CustomInputDecoration(
                  isMandatory: !widget.allowEmpty,
                  label: widget.label,
                  localizations: localizations,
                  errorText: widget.errorText,
                  icon: widget.icon,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.allowEmpty && _selected != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
                          onPressed: () => _select(null),
                        ),
                      Icon(controller.isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    ],
                  ),
                ),
                isEmpty: _selected == null,
                child: Text(_labelFor(_selected), maxLines: 1, softWrap: false, overflow: TextOverflow.fade),
              ),
            );
          },
        );
      },
    );
  }
}

class SimpleDropdown<T> extends StatelessWidget {
  final Iterable<MapEntry<T, Widget>> options;
  final T? selected;
  final void Function(T? value)? onChange;
  final FormFieldSetter<T>? onSaved;
  final bool isExpanded;
  final bool isNullable;
  final String? label;
  final AlignmentGeometry alignment;

  const SimpleDropdown({
    required this.options,
    required this.selected,
    this.onChange,
    this.onSaved,
    this.isNullable = false,
    this.isExpanded = true,
    super.key,
    this.label,
    this.alignment = AlignmentDirectional.centerStart,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<T>(
      label: label,
      isExpanded: isExpanded,
      selected: selected,
      onChange: onChange,
      onSaved: onSaved,
      options: options.map<DropdownMenuItem<T>>((entry) => DropdownMenuItem<T>(value: entry.key, child: entry.value)),
      alignment: alignment,
      isNullable: isNullable,
    );
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final Iterable<DropdownMenuItem<T>> options;
  final T? selected;
  final void Function(T? value)? onChange;
  final FormFieldSetter<T>? onSaved;
  final bool isExpanded;
  final bool isNullable;
  final String? label;
  final AlignmentGeometry alignment;

  const CustomDropdown({
    required this.options,
    required this.selected,
    this.onChange,
    this.onSaved,
    this.isNullable = false,
    this.isExpanded = true,
    super.key,
    this.label,
    this.alignment = AlignmentDirectional.centerStart,
  });

  @override
  Widget build(BuildContext context) {
    final items = options.toList();
    if (isNullable) {
      items.add(
        DropdownMenuItem<T>(
          value: null,
          child: Text(context.l10n.optionSelect, style: TextStyle(color: Theme.of(context).disabledColor)),
        ),
      );
    }
    return DropdownButtonFormField<T>(
      hint: label == null ? null : Text(label!),
      isExpanded: isExpanded,
      initialValue: selected,
      // FIXME: onChange method is required, in order to show as enabled: https://github.com/flutter/flutter/issues/57953
      onChanged: onChange ?? (_) {},
      onSaved: onSaved,
      items: items,
      alignment: alignment,
      decoration: CustomInputDecoration(label: label, localizations: context.l10n, isMandatory: !isNullable),
    );
  }
}
