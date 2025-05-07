import 'package:flutter/material.dart';

class IndexedToggleButtons extends StatelessWidget {
  final Function(int index) onPressed;
  final String Function(int index) getTitle;
  final String label;
  final int numOptions;
  final int? selected;

  const IndexedToggleButtons({
    super.key,
    required this.onPressed,
    required this.numOptions,
    required this.selected,
    required this.getTitle,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        ToggleButtons(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          onPressed: onPressed,
          isSelected: Iterable.generate(numOptions, (e) => e == selected).toList(),
          children:
              Iterable.generate(numOptions, (e) {
                return Padding(padding: const EdgeInsets.all(8), child: Text(getTitle(e)));
              }).toList(),
        ),
      ],
    );
  }
}
