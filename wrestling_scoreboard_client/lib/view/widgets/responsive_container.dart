import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_client/view/widgets/buttons.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final Alignment alignment;

  const ResponsiveContainer({required this.child, super.key, this.alignment = Alignment.topCenter});

  @override
  Widget build(BuildContext context) {
    return Align(alignment: alignment, child: SizedBox(width: _calculateContainerSize(context), child: child));
  }

  double? _calculateContainerSize(BuildContext context) {
    return context.isMediumScreenOrLarger ? mediumScreenMinWidth : null;
  }
}

class ResponsiveScrollView extends StatelessWidget {
  final Widget child;

  const ResponsiveScrollView({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(child: SingleChildScrollView(child: child));
  }
}

class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveColumn({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(child: SingleChildScrollView(child: Column(children: children)));
  }
}

abstract class ResponsiveScaffoldActionItemBuilder {
  Widget buildForAppBar(BuildContext context);

  Widget buildForPopupMenu(BuildContext context);

  final ResponsiveScaffoldActionItemStyle style;

  const ResponsiveScaffoldActionItemBuilder({this.style = ResponsiveScaffoldActionItemStyle.icon});
}

class DefaultResponsiveScaffoldActionItem extends ResponsiveScaffoldActionItemBuilder {
  final Widget icon;
  final String label;
  final FutureOr<void> Function()? onTap;

  const DefaultResponsiveScaffoldActionItem({super.style, required this.icon, required this.label, this.onTap});

  @override
  Widget buildForAppBar(BuildContext context) {
    if (style == ResponsiveScaffoldActionItemStyle.elevatedIconAndText) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: AsyncElevatedButton(icon: icon, onTap: onTap, label: Text(label)),
      );
    }
    return AsyncIconButton(onTap: onTap, icon: icon, tooltip: label);
  }

  @override
  Widget buildForPopupMenu(BuildContext context) {
    return MenuItemButton(onPressed: onTap, child: ListTile(leading: icon, title: Text(label)));
  }
}

class ConsumerResponsiveScaffoldActionItem<T> extends ResponsiveScaffoldActionItemBuilder {
  final Future<T> Function(WidgetRef ref) futureBuilder;
  final Widget Function(BuildContext context, T data) iconBuilder;
  final String Function(T data) labelBuilder;
  final FutureOr<void> Function(T data)? onTap;

  const ConsumerResponsiveScaffoldActionItem({
    super.style,
    required this.futureBuilder,
    required this.iconBuilder,
    required this.labelBuilder,
    this.onTap,
  });

  @override
  Widget buildForAppBar(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return LoadingBuilder<T>.icon(
          future: futureBuilder(ref),
          builder: (context, data) {
            final onTapData = onTap == null ? null : () => onTap?.call(data);
            final iconData = iconBuilder(context, data);
            final labelData = labelBuilder(data);
            if (style == ResponsiveScaffoldActionItemStyle.elevatedIconAndText) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AsyncElevatedButton(icon: iconData, onTap: onTapData, label: Text(labelData)),
              );
            }
            return AsyncIconButton(onTap: onTapData, icon: iconData, tooltip: labelData);
          },
        );
      },
    );
  }

  @override
  Widget buildForPopupMenu(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return LoadingBuilder<T>.icon(
          future: futureBuilder(ref),
          builder: (context, data) {
            return MenuItemButton(
              onPressed: onTap == null ? null : () => onTap?.call(data),
              child: ListTile(leading: iconBuilder(context, data), title: Text(labelBuilder(data))),
            );
          },
        );
      },
    );
  }
}

enum ResponsiveScaffoldActionItemStyle { icon, elevatedIconAndText }

class ResponsiveScaffoldActions extends StatelessWidget {
  final List<ResponsiveScaffoldActionItemBuilder> actionContents;

  const ResponsiveScaffoldActions({super.key, required this.actionContents});

  @override
  Widget build(BuildContext context) {
    final showActionsInAppBar = context.isMediumScreenOrLarger || actionContents.length <= 2;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showActionsInAppBar) ...actionContents.map((a) => a.buildForAppBar(context)),
          Visibility(
            visible: !showActionsInAppBar,
            // Maintain state so the popup menu still finds its ancestor
            maintainState: true,
            maintainSize: false,
            child: DefaultPopupMenuButton(actionContents: actionContents),
          ),
        ],
      ),
    );
  }
}

class DefaultPopupMenuButton extends StatelessWidget {
  final List<ResponsiveScaffoldActionItemBuilder> actionContents;

  const DefaultPopupMenuButton({super.key, required this.actionContents});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder:
          (context, controller, child) => IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: const Icon(Icons.more_vert),
            tooltip: MaterialLocalizations.of(context).popupMenuLabel,
          ),
      menuChildren: actionContents.map((a) => a.buildForPopupMenu(context)).toList(),
    );
  }
}
