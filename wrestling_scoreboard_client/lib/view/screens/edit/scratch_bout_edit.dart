import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/weight_class.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/bout_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ScratchBoutEdit extends BoutEdit {
  final ScratchBout scratchBout;

  ScratchBoutEdit({required this.scratchBout, super.key})
    : super(boutConfig: scratchBout.boutConfig, bout: scratchBout.bout);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ScratchBoutEditState();
}

class ScratchBoutEditState extends BoutEditState<ScratchBoutEdit> {
  late WeightClass _weightClass;

  @override
  void initState() {
    super.initState();
    _weightClass = widget.scratchBout.weightClass;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return buildEdit(
      context,
      id: widget.bout?.id,
      classLocale: localizations.bout,
      fields: [
        ListTile(
          title: SearchableDropdown<WeightClass>(
            allowEmpty: false,
            icon: const Icon(Icons.fitness_center),
            selectedItem: _weightClass,
            label: context.l10n.weightClass,
            context: context,
            onSaved:
                (WeightClass? value) => setState(() {
                  if (value != null) _weightClass = value;
                }),
            itemAsString: (u) => u.localize(context),
            asyncItems: (String filter) async {
              final boutWeightClasses = await availableWeightClasses;
              return boutWeightClasses.toList();
            },
          ),
        ),
      ],
      getRedMemberships:
          () async => await ref.readAsync(manyDataStreamProvider<Membership, Null>(ManyProviderData()).future),
      getBlueMemberships:
          () async => await ref.readAsync(manyDataStreamProvider<Membership, Null>(ManyProviderData()).future),
    );
  }

  @override
  Future<void> handleNested(Bout dataObject) async {
    var scratchBout = widget.scratchBout.copyWith(weightClass: _weightClass);
    scratchBout = scratchBout.copyWithId(await (await ref.read(dataManagerProvider)).createOrUpdateSingle(scratchBout));
  }

  Future<List<WeightClass>> get availableWeightClasses async {
    return await (await ref.read(dataManagerProvider)).readMany<WeightClass, Null>();
  }
}
