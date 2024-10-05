import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/scaled_text.dart';
import 'package:wrestling_scoreboard_client/view/widgets/themed.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ClassificationPointsDisplay extends ConsumerWidget {
  final Iterable<ParticipantState?> participationStates;
  final Color color;

  const ClassificationPointsDisplay({required this.participationStates, required this.color, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participationStatesFuture = Future.wait(participationStates.map((participationState) async {
      return participationState == null
          ? null
          : ref.watch(singleDataStreamProvider<ParticipantState>(
              SingleProviderData<ParticipantState>(initialData: participationState, id: participationState.id!),
            ).future);
    }));
    return ThemedContainer(
      color: color,
      child: Center(
        child: LoadingBuilder<List<ParticipantState?>>(
            future: participationStatesFuture,
            initialData: null, // Handle initial data via the stream
            builder: (context, participationStates) {
              return ScaledText(
                TeamMatch.getClassificationPoints(participationStates).toString(),
                fontSize: 36,
                minFontSize: 16,
                softWrap: false,
              );
            }),
      ),
    );
  }
}

class CommonElements {
  static List<Widget> getTeamHeader(Team home, Team guest, List<Bout> bouts, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width / 100;
    final edgeInsets = EdgeInsets.all(padding);

    return [
      ThemedContainer(
          color: Colors.red.shade800,
          padding: edgeInsets,
          child: Center(
            child: ScaledText(
              home.name,
              fontSize: 28,
              minFontSize: 16,
            ),
          )),
      Row(
        children: [
          Expanded(
            child: ClassificationPointsDisplay(
              participationStates: bouts.map((bout) => bout.r),
              color: Colors.red.shade900,
            ),
          ),
          Expanded(
            child: ClassificationPointsDisplay(
              participationStates: bouts.map((bout) => bout.b),
              color: Colors.blue.shade900,
            ),
          ),
        ],
      ),
      ThemedContainer(
        color: Colors.blue.shade800,
        padding: edgeInsets,
        child: Center(
          child: ScaledText(
            guest.name,
            fontSize: 28,
            minFontSize: 16,
          ),
        ),
      ),
    ];
  }
}
