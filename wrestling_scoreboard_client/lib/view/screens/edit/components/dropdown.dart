import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MembershipDropdown extends ConsumerWidget {
  final Future<Iterable<Membership>> Function() getOrSetMemberships;
  final void Function(Membership? membership)? onChange;
  final void Function(Membership? membership)? onSave;
  final Membership? selectedItem;
  final String label;
  final Organization? organization;
  final bool allowEmpty;

  const MembershipDropdown({
    super.key,
    required this.getOrSetMemberships,
    this.selectedItem,
    required this.label,
    this.organization,
    this.onChange,
    required this.onSave,
    this.allowEmpty = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingBuilder<Map<int, AuthService>>(
      future: ref.watch(orgAuthNotifierProvider),
      builder: (context, authServiceMap) {
        return SearchableDropdown<Membership>(
          selectedItem: selectedItem,
          label: label,
          context: context,
          onChanged: onChange,
          onSaved: onSave,
          itemAsString: (u) => u.info + (u.id == null ? ' (API)' : ''),
          asyncItems: (String filter) async {
            return _filterMemberships(ref, filter, organization, await getOrSetMemberships());
          },
          allowEmpty: allowEmpty,
          disableFilter: true,
          containerBuilder: (context, popupWidget) {
            return Column(
              children: [
                if (authServiceMap[organization?.id] == null)
                  const PaddedCard(
                    child: Text(
                        "⚠ You have not specified any credentials for this organization, therefore you can't search for sensitive data."),
                  ),
                Expanded(child: popupWidget),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<Membership>> _filterMemberships(
    WidgetRef ref,
    String filter,
    Organization? organization,
    Iterable<Membership> memberships,
  ) async {
    filter = filter.trim().toLowerCase();
    if (filter.isEmpty) {
      return memberships.toList();
    }
    final number = int.tryParse(filter);
    if (number == null) {
      return memberships.where((item) => item.person.fullName.toLowerCase().contains(filter)).toList();
    }

    // If filter string is a number, search for membership no or at API provider, if present.
    filter = number.toString();
    final filteredMemberships = memberships
        .where((item) => (item.orgSyncId?.contains(filter) ?? false) || (item.no?.contains(filter) ?? false))
        .toList();

    const enableApiProviderSearch = true;
    if (enableApiProviderSearch) {
      final authService = (await ref.read(orgAuthNotifierProvider))[organization?.id];
      if (authService != null) {
        final providerResults = await (await ref.read(dataManagerNotifierProvider)).search(
          searchTerm: filter,
          type: Membership,
          organizationId: organization?.id,
          authService: authService,
          includeApiProviderResults: true,
        );
        Iterable<Membership> providerMemberships =
            providerResults[getTableNameFromType(Membership)]?.map((membership) => membership as Membership) ?? [];
        // Remove all memberships, which are already in the list.
        providerMemberships =
            providerMemberships.where((m) => filteredMemberships.where((fm) => fm.no == m.no).isEmpty);
        filteredMemberships.addAll(providerMemberships);
      }
    }

    return filteredMemberships;
  }
}
