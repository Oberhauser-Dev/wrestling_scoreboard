import 'package:flutter/material.dart';

class PaddedCard extends StatelessWidget {
  final Widget child;

  const PaddedCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
