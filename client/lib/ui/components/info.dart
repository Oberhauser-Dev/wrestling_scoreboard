import 'package:common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/grouped_list.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class InfoWidget extends StatelessWidget {
  final DataObject obj;
  final Widget editPage;
  final List<Widget> children;
  final String classLocale;

  const InfoWidget({
    required this.obj,
    required this.editPage,
    required this.children,
    required this.classLocale,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListGroup(
      header: HeadingItem(
        title: localizations.info,
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
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text('${localizations.remove} $classLocale?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(localizations.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        dataProvider.deleteSingle(obj);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: Text(localizations.ok),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      items: children,
    );
  }
}
