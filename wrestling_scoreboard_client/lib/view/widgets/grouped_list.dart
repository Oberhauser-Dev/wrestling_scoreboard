import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';

/// A ListItem that contains data to display a heading.
class HeadingItem extends StatelessWidget {
  final String? title;
  final Widget? trailing;

  const HeadingItem({this.title, this.trailing, super.key});

  @override
  Widget build(BuildContext context) => ListTile(
        title: title != null ? HeadingText(title!) : null,
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

  const ContentItem({required this.title, this.subtitle, this.icon, this.onTap, this.trailing, super.key});

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

class GroupedList extends StatelessWidget {
  final Widget header;
  final Iterable<Widget> items;

  const GroupedList({required this.header, this.items = const [], super.key});

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
          style: Theme.of(context).textTheme.bodySmall,
        )),
      ));
    }
    return ListView(children: tiles);
  }
}
