import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';

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

class ResponsiveScaffoldActionItem {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;
  final ResponsiveScaffoldActionItemStyle style;

  ResponsiveScaffoldActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.style = ResponsiveScaffoldActionItemStyle.icon,
  });
}

enum ResponsiveScaffoldActionItemStyle { icon, elevatedIconAndText }

class ResponsiveScaffoldActions extends StatelessWidget {
  final List<ResponsiveScaffoldActionItem> actionContents;

  const ResponsiveScaffoldActions({super.key, required this.actionContents});

  @override
  Widget build(BuildContext context) {
    final showActions = context.isMediumScreenOrLarger || actionContents.length <= 1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showActions)
          ...actionContents.map((a) {
            if (a.style == ResponsiveScaffoldActionItemStyle.elevatedIconAndText) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton.icon(icon: a.icon, onPressed: a.onTap, label: Text(a.label)),
              );
            }
            return IconButton(onPressed: a.onTap, icon: a.icon, tooltip: a.label);
          }),
        Visibility(
          visible: !showActions,
          // Maintain state so the popup menu still finds its ancestor
          maintainState: true,
          maintainSize: false,
          child: AutoClosePopupMenuButton(actionContents: actionContents),
        ),
      ],
    );
  }
}

class AutoClosePopupMenuButton extends StatefulWidget {
  final List<ResponsiveScaffoldActionItem> actionContents;

  const AutoClosePopupMenuButton({super.key, required this.actionContents});

  @override
  State<AutoClosePopupMenuButton> createState() => _AutoClosePopupMenuButtonState();
}

class _AutoClosePopupMenuButtonState extends State<AutoClosePopupMenuButton> with WidgetsBindingObserver {
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _updateMetrics();
  }

  void _updateMetrics() {
    if (_isOpen && View.of(context).physicalSize.width > mediumScreenMinWidth) {
      // Close the popup menu, when the size gets larger, so it is closed, when the three dot button disappears.
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onOpened: () => _isOpen = true,
      onCanceled: () => _isOpen = false,
      onSelected: (_) => _isOpen = false,
      itemBuilder: (context) {
        return widget.actionContents
            .map((a) => PopupMenuItem<String>(onTap: a.onTap, child: ListTile(leading: a.icon, title: Text(a.label))))
            .toList();
      },
    );
  }
}
