import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

class Home extends ConsumerStatefulWidget {
  static const route = 'home';

  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.home)),
      body: ResponsiveColumn(children: [
        ListTile(title: Text(localizations.leagues), leading: const Icon(Icons.emoji_events)),
        GridView.extent(
          maxCrossAxisExtent: 150,
          shrinkWrap: true,
          children: _generateDummies(4),
        ),
        const SizedBox(height: 16),
        ListTile(title: Text(localizations.clubs), leading: const Icon(Icons.foundation)),
        GridView.extent(
          maxCrossAxisExtent: 150,
          shrinkWrap: true,
          children: _generateDummies(1),
        ),
        const SizedBox(height: 16),
        ListTile(title: Text(localizations.teams), leading: const Icon(Icons.group)),
        GridView.extent(
          maxCrossAxisExtent: 150,
          shrinkWrap: true,
          children: _generateDummies(3),
        ),
        const SizedBox(height: 16),
        ListTile(title: Text(localizations.persons), leading: const Icon(Icons.person)),
        GridView.extent(
          maxCrossAxisExtent: 150,
          shrinkWrap: true,
          children: _generateDummies(5),
        ),
        const SizedBox(height: 16),
        ListTile(title: Text(localizations.competitions), leading: const Icon(Icons.leaderboard)),
        GridView.extent(
          maxCrossAxisExtent: 150,
          shrinkWrap: true,
          children: _generateDummies(3),
        ),
      ]),
    );
  }

  List<Widget> _generateDummies(int i) {
    return Iterable.generate(
      i,
      (index) {
        return Card(
            clipBehavior: Clip.hardEdge,
            child: Container(
              decoration:
                  const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/icons/launcher.png'))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      color: const Color.fromARGB(125, 0, 0, 0),
                      child: const Center(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Sample item'),
                      ))),
                ],
              ),
            ));
      },
    ).toList();
  }
}
