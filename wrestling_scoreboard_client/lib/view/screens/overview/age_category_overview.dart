import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/age_category_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class AgeCategoryOverview extends ConsumerWidget {
  static const route = 'age_category';

  static void navigateTo(BuildContext context, AgeCategory dataObject) {
    context.push('/$route/${dataObject.id}');
  }

  final int id;
  final AgeCategory? ageCategory;

  const AgeCategoryOverview({super.key, required this.id, this.ageCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<AgeCategory>(
      id: id,
      initialData: ageCategory,
      builder: (context, ageCategory) {
        final description = InfoWidget(
          obj: ageCategory,
          editPage: AgeCategoryEdit(ageCategory: ageCategory),
          onDelete: () async => (await ref.read(dataManagerProvider)).deleteSingle<AgeCategory>(ageCategory),
          classLocale: localizations.ageCategory,
          children: [
            ContentItem(title: ageCategory.name, subtitle: localizations.name, icon: Icons.description),
            ContentItem(
              title: ageCategory.minAge.toString(),
              subtitle: '${localizations.age} (${localizations.minimum})',
              icon: Icons.school,
            ),
            ContentItem(
              title: ageCategory.maxAge.toString(),
              subtitle: '${localizations.age} (${localizations.maximum})',
              icon: Icons.school,
            ),
          ],
        );
        return FavoriteScaffold<AgeCategory>(
          dataObject: ageCategory,
          label: localizations.ageCategory,
          details: ageCategory.name,
          tabs: [Tab(child: HeadingText(localizations.info))],
          body: TabGroup(items: [description]),
        );
      },
    );
  }
}
