import 'package:collection/collection.dart';
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
  final String? label;
  final Organization? organization;
  final bool allowEmpty;
  final Iterable<Club>? clubFilter;

  const MembershipDropdown({
    super.key,
    required this.getOrSetMemberships,
    this.selectedItem,
    this.label,
    this.organization,
    this.onChange,
    required this.onSave,
    this.allowEmpty = true,
    this.clubFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoadingBuilder<Map<int, AuthService>>(
      future: ref.watch(orgAuthProvider),
      builder: (context, authServiceMap) {
        return SearchableDropdown<Membership>(
          selectedItem: selectedItem,
          label: label,
          context: context,
          onChanged: onChange,
          onSaved: onSave,
          itemBuilder: (context, item) {
            return Row(
              spacing: 12,
              children: [
                Expanded(child: Text(item.info)),
                if (item.id == null)
                  Chip(label: const Text('API'), backgroundColor: Colors.amber.withValues(alpha: 0.2)),
                if (clubFilter case final filter? when filter.isNotEmpty && !filter.contains(item.club))
                  Chip(label: Text(item.club.name), backgroundColor: Colors.red.withValues(alpha: 0.2)),
              ],
            );
          },
          asyncItems: (String filter) async {
            return _filterMemberships(ref, filter, organization, await getOrSetMemberships());
          },
          allowEmpty: allowEmpty,
          containerBuilder: (context, popupWidget) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (authServiceMap[organization?.id] == null)
                  const PaddedCard(
                    child: Text(
                      "⚠ You have not specified any credentials for this organization, therefore you can't search for sensitive data.",
                    ),
                  ),
                popupWidget,
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
      final authService = await ref.read(orgAuthProvider.notifier).getByOrganization(organization?.id);
      if (authService != null) {
        final providerResults = await (await ref.read(dataManagerProvider)).search(
          searchTerm: filter,
          type: Membership,
          organizationId: organization?.id,
          authService: authService,
          includeApiProviderResults: true,
        );
        Iterable<Membership> providerMemberships =
            providerResults[getTableNameFromType(Membership)]?.map((membership) => membership as Membership) ?? [];
        // Remove all memberships, which are already in the list.
        providerMemberships = providerMemberships.where(
          (m) => filteredMemberships.where((fm) => fm.no == m.no).isEmpty,
        );
        filteredMemberships.addAll(providerMemberships);
      }
    }

    return filteredMemberships.sorted((a, b) {
      if (a.no == null && b.no == null) return a.person.fullName.compareTo(b.person.fullName);
      if (a.no == null) return 1;
      if (b.no == null) return -1;
      final aNo = int.tryParse(a.no!);
      final bNo = int.tryParse(b.no!);
      if (aNo != null && bNo != null) {
        return aNo.compareTo(bNo);
      }
      return a.no!.compareTo(b.no!);
    });
  }
}
