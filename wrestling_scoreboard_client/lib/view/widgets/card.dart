import 'package:flutter/material.dart';

enum _CardVariant { elevated, filled, outlined }

class PaddedCard extends StatelessWidget {
  final Widget child;
  final _CardVariant _variant;

  const PaddedCard({required this.child, super.key}) : _variant = _CardVariant.elevated;

  @override
  Widget build(BuildContext context) {
    final paddedChild = Padding(padding: const EdgeInsets.all(16), child: child);
    return switch (_variant) {
      _CardVariant.elevated => Card(child: paddedChild),
      _CardVariant.filled => Card.filled(child: paddedChild),
      _CardVariant.outlined => Card.outlined(child: paddedChild),
    };
  }

  const PaddedCard.filled({required this.child, super.key}) : _variant = _CardVariant.filled;

  const PaddedCard.outlined({required this.child, super.key}) : _variant = _CardVariant.outlined;
}

class IconCard extends StatelessWidget {
  final Widget icon;
  final Widget child;

  const IconCard({required this.icon, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return PaddedCard(child: ListTile(leading: icon, title: child));
  }
}
