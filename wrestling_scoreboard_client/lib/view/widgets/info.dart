import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class InfoWidget extends StatelessWidget {
  final DataObject obj;
  final Widget editPage;
  final List<Widget> children;
  final String classLocale;
  final VoidCallback onDelete;

  const InfoWidget({
    required this.obj,
    required this.editPage,
    required this.children,
    required this.classLocale,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return GroupedList(
      header: HeadingItem(
        trailing: Wrap(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => editPage,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmDelete = await showOkCancelDialog<bool>(
                  context: context,
                  child: Text('${localizations.remove} $classLocale?'),
                  getResult: () => true,
                );
                if (confirmDelete == true && context.mounted) {
                  Navigator.of(context).pop();
                  onDelete();
                }
              },
            ),
          ],
        ),
      ),
      items: children,
    );
  }
}
