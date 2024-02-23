import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/rest.dart';

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
    final localizations = AppLocalizations.of(context)!;
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
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Text('${id == null ? localizations.add : localizations.edit} $typeLocalization'),
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
        onPressed: () => _handleSubmit(context),
        label: label,
      ),
    );
  }

  void _handleSubmit(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    try {
      await onSubmit();
    } on RestException catch (e) {
      developer.log(e.message);
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Column(
              children: [
                Text(localizations.invalidParameterException),
                Text(
                  e.message,
                  style: TextStyle(color: Theme.of(context).disabledColor, fontSize: 10),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(localizations.ok),
              ),
            ],
          ),
        );
      }
    }
  }
}