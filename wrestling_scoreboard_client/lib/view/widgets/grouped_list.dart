import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/search.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_common/common.dart';

/// A ListItem that contains data to display a heading.
class HeadingItem extends StatelessWidget {
  final String? title;
  final Widget? trailing;

  const HeadingItem({this.title, this.trailing, super.key});

  @override
  Widget build(BuildContext context) => ListTile(title: title != null ? HeadingText(title!) : null, trailing: trailing);
}

/// A ListItem that contains data to display a message.
class ContentItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Function()? onTap;
  final bool isDisabled;

  const ContentItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.trailing,
    this.isDisabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(title, style: isDisabled ? TextStyle(color: Theme.of(context).disabledColor) : null),
      subtitle: (subtitle != null) ? Text(subtitle!, style: TextStyle(color: Theme.of(context).disabledColor)) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class FilterableManyConsumer<T extends DataObject, S extends DataObject?> extends ConsumerWidget {
  final Widget? trailing;
  final String? hintText;
  final List<T>? initialData;
  final S? filterObject;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget? Function(BuildContext context, List<T> data)? prependBuilder;
  final Widget Function(BuildContext context, Object? exception, {StackTrace? stackTrace})? onException;
  final List<T> Function(List<T> data)? mapData;
  final bool shrinkWrap;
  final int Function(List<T> data)? getInitialIndex;

  const FilterableManyConsumer({
    required this.itemBuilder,
    this.trailing,
    this.hintText,
    this.prependBuilder,
    this.onException,
    this.initialData,
    this.filterObject,
    this.mapData,
    this.shrinkWrap = false,
    this.getInitialIndex,
    super.key,
  });

  factory FilterableManyConsumer.edit({
    required BuildContext context,
    required Widget Function(BuildContext context) editPageBuilder,
    required Widget Function(BuildContext context, T item) itemBuilder,
    Widget? trailing,
    String? hintText,
    List<T>? initialData,
    S? filterObject,
    Widget? Function(BuildContext context, List<T> data)? prependBuilder,
    Widget Function(BuildContext context, Object? exception, {StackTrace? stackTrace})? onException,
    List<T> Function(List<T> data)? mapData,
    int Function(List<T> data)? getInitialIndex,
    bool shrinkWrap = false,
  }) {
    return FilterableManyConsumer<T, S>(
      itemBuilder: itemBuilder,
      onException: onException,
      filterObject: filterObject,
      mapData: mapData,
      prependBuilder: prependBuilder,
      initialData: initialData,
      hintText: hintText,
      trailing: RestrictedAddButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: editPageBuilder)),
      ),
      shrinkWrap: shrinkWrap,
      getInitialIndex: getInitialIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ManyConsumer<T, S>(
      builder: (context, data) {
        if (mapData != null) {
          data = mapData!(data);
        }
        return SearchableGroupedList(
          trailing: trailing,
          items: data,
          itemBuilder: (context, e) => SingleConsumer<T>(id: e.id, initialData: e, builder: itemBuilder),
          prepend: prependBuilder == null ? null : prependBuilder!(context, data),
          shrinkWrap: shrinkWrap,
          initialItemIndex: getInitialIndex == null ? 0 : getInitialIndex!.call(data),
        );
      },
      initialData: initialData,
      filterObject: filterObject,
      onException: onException,
    );
  }
}

class SearchableGroupedList<T extends DataObject> extends ConsumerStatefulWidget {
  final Widget? prepend;
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget? trailing;
  final String? hintText;
  final bool shrinkWrap;
  final int initialItemIndex;

  const SearchableGroupedList({
    super.key,
    required this.itemBuilder,
    required this.items,
    this.prepend,
    this.trailing,
    this.hintText,
    this.shrinkWrap = false,
    this.initialItemIndex = 0,
  });

  @override
  ConsumerState<SearchableGroupedList<T>> createState() => _SearchableGroupedListState<T>();
}

class _SearchableGroupedListState<T extends DataObject> extends ConsumerState<SearchableGroupedList<T>> {
  late List<T> _filteredItems;
  Timer? _throttleTimer;

  @override
  void initState() {
    _filteredItems = widget.items;
    super.initState();
  }

  @override
  void dispose() {
    _throttleTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchableGroupedList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset list, if items have changed
    setState(() {
      _filteredItems = widget.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GroupedList(
      shrinkWrap: widget.shrinkWrap,
      initialItemIndex: widget.initialItemIndex,
      header: ListTile(
        leading: const Icon(Icons.search),
        title: TextField(
          autofocus: isOnDesktop,
          enabled: widget.items.isNotEmpty,
          decoration: InputDecoration(hintText: widget.hintText),
          onChanged: (searchTerm) async {
            _throttleTimer?.cancel();
            if (!isValidSearchTerm(searchTerm)) {
              setState(() {
                _filteredItems = widget.items;
              });
            } else {
              _throttleTimer = Timer(throttleDuration, () async {
                try {
                  // TODO: Support server side filter type
                  final results = await (await ref.read(
                    dataManagerNotifierProvider,
                  )).search(searchTerm: searchTerm, type: T);
                  final Set<T> parsedResults = results[getTableNameFromType(T)]?.map((item) => item as T).toSet() ?? {};
                  setState(() {
                    // TODO: Remove intersection, if support server side filter type
                    _filteredItems = parsedResults.intersection(widget.items.toSet()).toList();
                  });
                } catch (e, st) {
                  if (context.mounted) {
                    await showExceptionDialog(context: context, exception: e, stackTrace: st);
                  }
                }
              });
            }
          },
        ),
        trailing: widget.trailing,
      ),
      itemBuilder: (context, index) {
        if (widget.prepend != null) {
          if (index <= 0) {
            return widget.prepend!;
          }
          index--;
        }
        return widget.itemBuilder(context, _filteredItems[index]);
      },
      itemCount: widget.prepend == null ? _filteredItems.length : (_filteredItems.length + 1),
    );
  }
}

class GroupedList extends StatelessWidget {
  final Widget header;
  final Widget Function(BuildContext, int index) itemBuilder;
  final int itemCount;
  final int initialItemIndex;
  final bool shrinkWrap;

  GroupedList({
    required this.header,
    required this.itemBuilder,
    super.key,
    int? initialItemIndex,
    required this.itemCount,
    this.shrinkWrap = false,
  }) : initialItemIndex = math.max(0, initialItemIndex ?? 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header,
        if (itemCount <= 0)
          ListTile(title: Center(child: Text(context.l10n.noItems, style: Theme.of(context).textTheme.bodySmall)))
        else if (shrinkWrap)
          ScrollablePositionedList.builder(
            shrinkWrap: true,
            itemCount: itemCount,
            initialScrollIndex: initialItemIndex,
            itemBuilder: (context, index) => itemBuilder(context, index),
          )
        else
          Expanded(
            child: ScrollablePositionedList.builder(
              shrinkWrap: false,
              itemCount: itemCount,
              initialScrollIndex: initialItemIndex,
              itemBuilder: (context, index) => itemBuilder(context, index),
            ),
          ),
      ],
    );
  }
}
