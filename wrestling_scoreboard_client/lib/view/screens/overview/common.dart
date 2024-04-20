import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaffold.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class AbstractOverview<T extends DataObject> {
  Widget buildOverview(
    BuildContext context,
    WidgetRef ref, {
    required String classLocale,
    required Widget editPage,
    required VoidCallback onDelete,
    required List<Widget> tiles,
    required int dataId,
    T? initialData,
  });
}

class AppBarTitle extends StatelessWidget {
  final String label;
  final String details;

  const AppBarTitle({super.key, required this.label, required this.details});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        Text(
          '  $details',
          style: TextStyle(color: Theme.of(context).disabledColor),
        ),
      ],
    );
  }
}

class OverviewScaffold<T extends DataObject> extends ConsumerWidget {
  const OverviewScaffold({
    super.key,
    required this.body,
    required this.label,
    required this.details,
    this.actions,
    required this.dataObject,
  });

  final Widget body;
  final String label;
  final String details;
  final List<Widget>? actions;
  final T dataObject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final tableName = getTableNameFromType(T);
    return WindowStateScaffold(
      appBarTitle: AppBarTitle(label: label, details: details),
      actions: [
        ...?actions,
        LoadingBuilder(
            future: ref.watch(favoritesNotifierProvider),
            builder: (BuildContext context, favorites) {
              final isFavorite = favorites[tableName]?.contains(dataObject.id) ?? false;
              return IconButton(
                onPressed: () {
                  final notifier = ref.read(favoritesNotifierProvider.notifier);
                  if (isFavorite) {
                    notifier.removeFavorite(tableName, dataObject.id!);
                  } else {
                    notifier.addFavorite(tableName, dataObject.id!);
                  }
                },
                icon: isFavorite ? const Icon(Icons.star) : const Icon(Icons.star_outline),
                tooltip: localizations.favorite,
              );
            }),
      ],
      body: body,
    );
  }
}
