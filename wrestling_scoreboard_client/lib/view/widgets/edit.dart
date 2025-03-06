import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

class EditWidget extends StatelessWidget {
  final String typeLocalization;
  final int? id;
  final Future<void> Function() onSubmit;
  final List<Widget> items;

  const EditWidget({
    super.key,
    required this.typeLocalization,
    required this.onSubmit,
    required this.items,
    this.id,
  });

  List<Widget> _buildActions(BuildContext context) {
    final localizations = context.l10n;
    return [
      EditAction(
        icon: const Icon(Icons.save),
        label: Text(localizations.save),
        onSubmit: onSubmit,
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
  final List<Widget> Function(BuildContext context) buildActions;
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
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Text('${id == null ? localizations.create : localizations.edit} $typeLocalization'),
            if (id != null)
              Text(
                ' #$id',
                style: TextStyle(color: Theme.of(context).disabledColor),
              ),
          ],
        ),
        actions: buildActions(context),
      ),
      body: ResponsiveColumn(
        children: items,
      ),
    );
  }
}

class EditAction extends StatelessWidget {
  final Widget icon;
  final Widget label;
  final Future<void> Function() onSubmit;

  const EditAction({super.key, required this.icon, required this.label, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ElevatedButton.icon(
        icon: icon,
        onPressed: () => catchAsync(context, onSubmit),
        label: label,
      ),
    );
  }
}
