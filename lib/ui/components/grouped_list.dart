import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Widget? buildLeading(BuildContext context) => null;

  @override
  Widget buildTitle(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 10, top: 20),
        child: Text(
          heading,
          style: Theme.of(context).textTheme.headline5,
        ));
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

  Widget? buildLeading(BuildContext context) => icon != null ? Icon(icon) : null;

  @override
  Widget buildTitle(BuildContext context) => Text(title);

  @override
  Widget? buildSubtitle(BuildContext context) {
    return (this.body != null) ? Text(this.body!) : null;
  }

  @override
  Function()? buildOnTab() {
    return this.onTab;
  }
}

class GroupedList extends StatelessWidget {
  final List<ListItem> items;

  GroupedList(this.items);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: item.buildLeading(context),
            title: item.buildTitle(context),
            subtitle: item.buildSubtitle(context),
            onTap: item.buildOnTab(),
          );
        });
  }
}
