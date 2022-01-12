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
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget? buildLeading(BuildContext context) => null;

  @override
  Widget buildTitle(BuildContext context) {
    return HeadingText(heading);
  }

  @override
  Widget? buildSubtitle(BuildContext context) => null;

  @override
  Function()? buildOnTab() {
    return null;
  }
}

/// A ListItem that contains data to display a message.
class ContentItem implements ListItem {
  final IconData? icon;
  final String title;
  final String? body;
  final Function()? onTab;

  ContentItem(this.title, {this.body, this.icon, this.onTab});

  @override
  Widget? buildLeading(BuildContext context) => icon != null ? Icon(icon) : null;

  @override
  Widget buildTitle(BuildContext context) => Text(title);

  @override
  Widget? buildSubtitle(BuildContext context) {
    return (body != null) ? Text(body!) : null;
  }

  @override
  Function()? buildOnTab() {
    return onTab;
  }
}

class ListGroup extends StatelessWidget {
  final HeadingItem header;
  final Iterable<ContentItem> items;

  const ListGroup({required this.header, this.items = const [], Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> tiles = [];
    tiles.add(ListTile(
      leading: header.buildLeading(context),
      title: header.buildTitle(context),
      subtitle: header.buildSubtitle(context),
      onTap: header.buildOnTab(),
    ));
    if (items.isNotEmpty) {
      tiles.addAll(items.map((e) => ListTile(
            leading: e.buildLeading(context),
            title: e.buildTitle(context),
            subtitle: e.buildSubtitle(context),
            onTap: e.buildOnTab(),
          )));
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
