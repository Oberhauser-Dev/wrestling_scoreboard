import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  String heading;

  HeadingText(this.heading);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 10, top: 20),
        child: Text(
          heading.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        ));
  }
}
