import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditWidget extends StatelessWidget {
  final String typeLocalization;
  final int? id;
  final Function onSubmit;
  final List<Widget> items;

  const EditWidget({Key? key, required this.typeLocalization, required this.onSubmit, required this.items, this.id})
      : super(key: key);

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
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: () => onSubmit(),
                label: Text(localizations.save),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1140),
            child: Column(
              children: items,
            ),
          ),
        ),
      ),
    );
  }
}
