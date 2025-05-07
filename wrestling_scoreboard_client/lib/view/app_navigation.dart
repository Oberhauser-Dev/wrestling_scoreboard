import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/explore.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/home.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/more.dart';

/// This is the stateful widget that the main application instantiates.
class AppNavigation extends StatefulWidget {
  final Widget child;

  const AppNavigation({super.key, required this.child});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _AppNavigationState extends State<AppNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          context.go('/${Home.route}');
          break;
        case 1:
          context.go('/${Explore.route}');
          break;
        default:
          context.go('/${MoreScreen.route}');
          break;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: localizations.start),
          BottomNavigationBarItem(icon: const Icon(Icons.explore), label: localizations.explore),
          BottomNavigationBarItem(icon: const Icon(Icons.more_horiz), label: localizations.more),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
