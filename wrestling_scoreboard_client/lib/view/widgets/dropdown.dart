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
    required Widget Function(BuildContext context, T item) itemBuilder,
    int Function(T a, T b)? sortBy,
    bool allowEmpty = true,
    required BuildContext context,
    Widget? icon,
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
             asyncItems: asyncItems,
             onFilter: onFilter,
             itemBuilder: itemBuilder,
             sortBy: sortBy,
             errorText: state.errorText,
             containerBuilder: containerBuilder,
             onChanged: (value) {
               state.didChange(value);
               onChanged?.call(value);
             },
           );
         },
       );

  /// Restores the previous behavior of building each item's display from a plain [String], which
  /// is also used as the default text filter and sort order unless [onFilter] or [sortBy] is given.
  SearchableDropdown.stringItems({
    required T? selectedItem,
    String? label,
    void Function(T? value)? onChanged,
    FormFieldSetter<T>? onSaved,
    required Future<List<T>> Function(String filter) asyncItems,
    bool Function(T item, String filter)? onFilter,
    required String Function(T item) itemAsString,
    int Function(T a, T b)? sortBy,
    bool allowEmpty = true,
    required BuildContext context,
    Widget? icon,
    bool disableFilter = false,
    Widget Function(BuildContext context, Widget popupWidget)? containerBuilder,
    Key? key,
  }) : this(
         selectedItem: selectedItem,
         label: label,
         onChanged: onChanged,
         onSaved: onSaved,
         asyncItems: asyncItems,
         onFilter:
             onFilter ??
             (disableFilter
                 ? null
                 : (item, filter) => itemAsString(item).toLowerCase().contains(filter.trim().toLowerCase())),
         itemBuilder: (context, item) => Text(itemAsString(item)),
         sortBy: sortBy ?? (a, b) => itemAsString(a).compareTo(itemAsString(b)),
         allowEmpty: allowEmpty,
         context: context,
         icon: icon,
         containerBuilder: containerBuilder,
         key: key,
       );
}

class _SearchableDropdownField<T> extends StatefulWidget {
  final T? selectedItem;
  final String? label;
  final Widget? icon;
  final bool allowEmpty;
  final Future<List<T>> Function(String filter) asyncItems;
  final bool Function(T item, String filter)? onFilter;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final int Function(T a, T b)? sortBy;
  final String? errorText;
  final Widget Function(BuildContext context, Widget popupWidget)? containerBuilder;
  final ValueChanged<T?> onChanged;

  const _SearchableDropdownField({
    required this.selectedItem,
    this.label,
    this.icon,
    required this.allowEmpty,
    required this.asyncItems,
    this.onFilter,
    required this.itemBuilder,
    this.sortBy,
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
    }
    final sortBy = widget.sortBy;
    if (sortBy != null) {
      items.sort(sortBy);
    }
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
                        title: widget.itemBuilder(context, item),
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
                child: _selected == null
                    ? const SizedBox.shrink()
                    : DefaultTextStyle.merge(
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        child: widget.itemBuilder(context, _selected as T),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}

class SimpleDropdown<T> extends StatelessWidget {
  final Iterable<DropdownMenuEntry<T>> options;
  final T? selected;
  final void Function(T? value)? onChange;
  final FormFieldSetter<T>? onSaved;
  final bool isExpanded;
  final bool isNullable;
  final String? label;

  const SimpleDropdown({
    required this.options,
    required this.selected,
    this.onChange,
    this.onSaved,
    this.isNullable = false,
    this.isExpanded = true,
    super.key,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    // DropdownMenuEntry.value is non-nullable, so a selectable "none" entry needs the entries'
    // type parameter to be nullable, regardless of whether T itself already is.
    final entries = <DropdownMenuEntry<T?>>[
      for (final option in options)
        DropdownMenuEntry<T?>(
          value: option.value,
          label: option.label,
          labelWidget: option.labelWidget,
          leadingIcon: option.leadingIcon,
          trailingIcon: option.trailingIcon,
          enabled: option.enabled,
          style: option.style,
        ),
      if (isNullable) DropdownMenuEntry<T?>(value: null, label: context.l10n.optionSelect),
    ];
    return DropdownMenuFormField<T?>(
      enableFilter: false,
      enableSearch: false,
      selectOnly: true,
      initialSelection: selected,
      dropdownMenuEntries: entries,
      expandedInsets: isExpanded ? EdgeInsets.zero : null,
      onSelected: onChange,
      onSaved: onSaved,
      decorationBuilder: (context, _) =>
          CustomInputDecoration(label: label, localizations: context.l10n, isMandatory: !isNullable),
    );
  }
}
