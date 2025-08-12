import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

class EditWidget extends StatelessWidget {
  final String typeLocalization;
  final int? id;
  final Future<void> Function() onSubmit;
  final List<Widget> items;

  const EditWidget({super.key, required this.typeLocalization, required this.onSubmit, required this.items, this.id});

  List<ResponsiveScaffoldActionItem> _buildActions(BuildContext context) {
    final localizations = context.l10n;
    return [
      ResponsiveScaffoldActionItem(
        icon: const Icon(Icons.save),
        label: localizations.save,
        onTap: onSubmit,
        style: ResponsiveScaffoldActionItemStyle.elevatedIconAndText,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CustomizableEditWidget(
      typeLocalization: typeLocalization,
      items: items,
      id: id,
      buildActions: _buildActions,
    );
  }
}

class CustomizableEditWidget extends StatelessWidget {
  final String typeLocalization;
  final int? id;
  final List<ResponsiveScaffoldActionItem> Function(BuildContext context) buildActions;
  final List<Widget> items;

  const CustomizableEditWidget({
    super.key,
    required this.typeLocalization,
    required this.items,
    this.id,
    required this.buildActions,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
        title: Row(
          children: [
            Text('${id == null ? localizations.create : localizations.edit} $typeLocalization'),
            if (id != null) Text(' #$id', style: TextStyle(color: Theme.of(context).disabledColor)),
          ],
        ),
        actions: [ResponsiveScaffoldActions(actionContents: buildActions(context))],
      ),
      body: ResponsiveColumn(children: items),
    );
  }
}
