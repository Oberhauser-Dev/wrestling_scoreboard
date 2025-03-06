import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/widgets/auth.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class InfoWidget extends StatelessWidget {
  final DataObject obj;
  final Widget editPage;
  final List<Widget> children;
  final String classLocale;
  final VoidCallback onDelete;
  final List<Widget> actions;

  const InfoWidget({
    required this.obj,
    required this.editPage,
    required this.children,
    required this.classLocale,
    required this.onDelete,
    this.actions = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return GroupedList(
      header: HeadingItem(
        trailing: Restricted(
          privilege: UserPrivilege.write,
          child: Wrap(
            children: [
              ...actions,
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
                  final confirmDelete = await showOkCancelDialog(
                    context: context,
                    child: Text('${localizations.remove} $classLocale?'),
                  );
                  if (confirmDelete && context.mounted) {
                    Navigator.of(context).pop();
                    onDelete();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
