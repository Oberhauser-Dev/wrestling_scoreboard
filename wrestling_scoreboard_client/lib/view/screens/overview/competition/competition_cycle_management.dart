import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/consumer.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionCycleManagement extends ConsumerStatefulWidget {
  final Competition competition;

  const CompetitionCycleManagement({super.key, required this.competition});

  @override
  ConsumerState<CompetitionCycleManagement> createState() => _CompetitionCycleManagementState();
}

class _CompetitionCycleManagementState extends ConsumerState<CompetitionCycleManagement> {
  final _controllers = LinkedScrollControllerGroup();
  late final ScrollController _headerController;
  final Map<String, ScrollController> _scrollControllers = {};

  final _ageCategoriesKey = UniqueKey();
  final _weightCategoriesKey = UniqueKey();

  ScrollController _addAndGet(String keyName) {
    return _scrollControllers.putIfAbsent(keyName, () => _controllers.addAndGet());
  }

  @override
  void initState() {
    super.initState();
    _headerController = _controllers.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return Column(
      children: [
        _CycleManagementListItem(
          label: localizations.cycle,
          controller: _headerController,
          cycleItemBuilder: (context, index) => Center(child: Text('${index + 1}')),
          lineHeight: 50,
        ),
        Divider(),
        ManyConsumer<CompetitionAgeCategory, Competition>(
          filterObject: widget.competition,
          builder: (context, competitionAgeCategories) {
            return ReorderableListView(
              key: _ageCategoriesKey,
              shrinkWrap: true,
              children:
                  competitionAgeCategories.map((e) {
                    final keyName = 'ac${e.id}';
                    final controller = _addAndGet(keyName);
                    return SingleConsumer<CompetitionAgeCategory>(
                      key: Key(keyName),
                      id: e.id,
                      initialData: e,
                      builder: (context, e) {
                        return _CycleManagementListItem(
                          label: e.ageCategory.name,
                          controller: controller,
                          cycleItemBuilder:
                              (context, index) => Checkbox(
                                value: !e.skippedCycles.contains(index),
                                onChanged: (value) async {
                                  final skippedCycles = e.skippedCycles.toSet();
                                  if (value == false) {
                                    skippedCycles.add(index);
                                  } else {
                                    skippedCycles.remove(index);
                                  }
                                  await (await ref.read(
                                    dataManagerNotifierProvider,
                                  )).createOrUpdateSingle(e.copyWith(skippedCycles: skippedCycles.toList()));
                                },
                              ),
                        );
                      },
                    );
                  }).toList(),
              onReorder: (oldIndex, newIndex) => _onReorder(oldIndex, newIndex, competitionAgeCategories),
            );
          },
        ),
        Divider(),
        ManyConsumer<CompetitionWeightCategory, Competition>(
          filterObject: widget.competition,
          builder: (context, competitionWeightCategories) {
            return ReorderableListView(
              key: _weightCategoriesKey,
              shrinkWrap: true,
              children:
                  competitionWeightCategories.map((e) {
                    final keyName = 'wc${e.id}';
                    final controller = _addAndGet(keyName);
                    return SingleConsumer<CompetitionWeightCategory>(
                      key: Key(keyName),
                      id: e.id,
                      initialData: e,
                      builder: (context, e) {
                        return _CycleManagementListItem(
                          label: e.name,
                          controller: controller,
                          cycleItemBuilder:
                              (context, index) => Checkbox(
                                value: !e.skippedCycles.contains(index),
                                onChanged: (value) async {
                                  final skippedCycles = e.skippedCycles.toSet();
                                  if (value == false) {
                                    skippedCycles.add(index);
                                  } else {
                                    skippedCycles.remove(index);
                                  }
                                  await (await ref.read(
                                    dataManagerNotifierProvider,
                                  )).createOrUpdateSingle(e.copyWith(skippedCycles: skippedCycles.toList()));
                                },
                              ),
                        );
                      },
                    );
                  }).toList(),
              onReorder: (oldIndex, newIndex) => _onReorder(oldIndex, newIndex, competitionWeightCategories),
            );
          },
        ),
      ],
    );
  }

  Future<void> _onReorder<T extends Orderable>(int oldIndex, int newIndex, List<T> orderedData) async {
    late int newPos;
    final oldPos = orderedData[oldIndex].pos;
    if (newIndex > oldIndex) {
      newPos = orderedData[newIndex - 1].pos;
      if (oldPos == newPos) {
        newPos += 1;
      }
    } else if (newIndex < oldIndex) {
      newPos = orderedData[newIndex].pos;
      if (oldPos == newPos) {
        newPos -= 1;
      }
    } else {
      return;
    }

    await catchAsync(context, () async {
      final e = orderedData[oldIndex];
      await (await ref.read(
        dataManagerNotifierProvider,
      )).reorder<T, Competition>(id: e.id!, newIndex: newPos, filterObject: widget.competition);
    });
  }
}

class _CycleManagementListItem extends StatelessWidget {
  final _labelWidth = 150.0;
  final _itemWidth = 50.0;
  final double lineHeight;
  final String label;
  final ScrollController controller;
  final NullableIndexedWidgetBuilder cycleItemBuilder;

  const _CycleManagementListItem({
    required this.label,
    required this.controller,
    required this.cycleItemBuilder,
    this.lineHeight = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: lineHeight,
      child: Row(
        children: [
          SizedBox(width: _labelWidth, child: Text(label)),
          Expanded(
            child: ListView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => SizedBox(width: _itemWidth, child: cycleItemBuilder(context, index)),
            ),
          ),
        ],
      ),
    );
  }
}
