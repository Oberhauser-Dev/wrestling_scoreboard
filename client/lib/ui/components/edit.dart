import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditWidget extends StatelessWidget {
  final String title;
  final Function onSubmit;
  final List<Widget> items;

  const EditWidget({Key? key, required this.title, required this.onSubmit, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: () => onSubmit(),
                label: Text(AppLocalizations.of(context)!.save),
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
