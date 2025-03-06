import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/admin/user_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/info.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class UserOverview extends ConsumerWidget {
  static const route = 'user';

  final int id;
  final SecuredUser? user;

  const UserOverview({super.key, required this.id, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = context.l10n;
    return SingleConsumer<SecuredUser>(
      id: id,
      initialData: user,
      builder: (context, data) {
        final description = InfoWidget(
          obj: data,
          editPage: UserEdit(
            user: data,
          ),
          onDelete: () async => (await ref.read(dataManagerNotifierProvider)).deleteSingle<SecuredUser>(data),
          classLocale: localizations.user,
          children: [
            ContentItem(
              title: data.username,
              subtitle: localizations.username,
              icon: Icons.person,
            ),
            ContentItem(
              title: data.createdAt.toDateTimeString(context),
              subtitle: localizations.joinedOn,
              icon: Icons.calendar_today,
            ),
            ContentItem(
              title: data.email ?? '-',
              subtitle: localizations.email,
              icon: Icons.email,
            ),
            ContentItem(
              title: data.privilege.name,
              subtitle: localizations.privilege,
              icon: Icons.key,
            ),
          ],
        );
        return OverviewScaffold(
          label: localizations.user,
          details: data.username,
          tabs: [
            Tab(child: HeadingText(localizations.info)),
          ],
          body: TabGroup(items: [
            description,
          ]),
        );
      },
    );
  }
}
