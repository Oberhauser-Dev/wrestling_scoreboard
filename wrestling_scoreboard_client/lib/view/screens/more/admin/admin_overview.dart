import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/admin/user_edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/more.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/admin/user_overview.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/tab_group.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class AdminOverview extends ConsumerWidget {
  static const route = 'admin';

  const AdminOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return OverviewScaffold(
      label: localizations.administration,
      details: '',
      tabs: [
        Tab(child: HeadingText(localizations.users)),
      ],
      body: TabGroup(items: [
        ManyConsumer<SecuredUser, Null>(
          builder: (BuildContext context, List<SecuredUser> users) {
            return GroupedList(
              header: HeadingItem(
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserEdit(),
                    ),
                  ),
                ),
              ),
              items: users.map(
                (e) => SingleConsumer<SecuredUser>(
                    id: e.id,
                    initialData: e,
                    builder: (context, data) {
                      return ContentItem(
                        title: data.username,
                        icon: Icons.account_circle,
                        onTap: () => handleSelectedUser(data, context),
                      );
                    }),
              ),
            );
          },
        ),
      ]),
    );
  }

  handleSelectedUser(SecuredUser user, BuildContext context) {
    context.push('/${MoreScreen.route}/${AdminOverview.route}/${UserOverview.route}/${user.id}');
  }
}
