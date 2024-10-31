import 'package:flutter/material.dart';

class DelayedTooltip extends StatelessWidget {
  final String? message;
  final Widget child;

  const DelayedTooltip({super.key, this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    if (message == null) return child;
    return Tooltip(message: message, waitDuration: const Duration(milliseconds: 1000), child: child);
  }
}
