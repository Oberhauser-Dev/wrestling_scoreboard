import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'font.dart';

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  Widget? buildLeading(BuildContext context);

  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget? buildSubtitle(BuildContext context);

  Function()? buildOnTab();
}

/// A ListItem that contains data to display a heading.
class HeadingItem extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const HeadingItem({required this.title, this.trailing, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: HeadingText(title),
        trailing: trailing,
      );
}

/// A ListItem that contains data to display a message.
class ContentItem extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Function()? onTap;

  const ContentItem({required this.title, this.subtitle, this.icon, this.onTap, this.trailing, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(title, style: onTap == null ? TextStyle(color: Theme.of(context).disabledColor) : null),
      subtitle: (subtitle != null) ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class ListGroup extends StatelessWidget {
  final Widget header;
  final Iterable<Widget> items;

  const ListGroup({required this.header, this.items = const [], Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> tiles = [];
    tiles.add(header);
    if (items.isNotEmpty) {
      tiles.addAll(items);
    } else {
      tiles.add(ListTile(
        title: Center(
            child: Text(
          AppLocalizations.of(context)!.noItems,
          style: Theme.of(context).textTheme.caption,
        )),
      ));
    }
    return Column(children: tiles);
  }
}

class GroupedList extends StatelessWidget {
  final List<Widget> items;

  const GroupedList({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Column(
          children: [
            if (index != 0) const Divider(indent: 16, endIndent: 16),
            item,
          ],
        );
      },
    );
  }
}
