import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String heading;

  const HeadingText(this.heading, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 10, top: 20),
        child: Text(
          heading.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        ));
  }
}
