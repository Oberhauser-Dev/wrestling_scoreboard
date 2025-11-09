import 'dart:async';

import 'package:flutter/material.dart';

class AsyncElevatedButton extends StatefulWidget {
  final Widget? icon;
  final FutureOr<void> Function()? onTap;
  final Widget label;

  const AsyncElevatedButton({super.key, this.icon, this.onTap, required this.label});

  @override
  State<AsyncElevatedButton> createState() => _AsyncElevatedButtonState();
}

class _AsyncElevatedButtonState extends State<AsyncElevatedButton> {
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: isDisabled ? SizedBox.square(dimension: 18, child: CircularProgressIndicator()) : widget.icon,
      onPressed:
          isDisabled || widget.onTap == null
              ? null
              : (widget.onTap is Future<void> Function()
                  ? () async {
                    setState(() {
                      isDisabled = true;
                    });
                    try {
                      await widget.onTap!();
                    } finally {
                      if (mounted) {
                        setState(() {
                          isDisabled = false;
                        });
                      }
                    }
                  }
                  : widget.onTap),
      label: widget.label,
    );
  }
}

class AsyncIconButton extends StatefulWidget {
  final Widget icon;
  final FutureOr<void> Function()? onTap;
  final String tooltip;

  const AsyncIconButton({super.key, required this.icon, this.onTap, required this.tooltip});

  @override
  State<AsyncIconButton> createState() => _AsyncIconButtonState();
}

class _AsyncIconButtonState extends State<AsyncIconButton> {
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: widget.tooltip,
      icon: isDisabled ? SizedBox.square(dimension: 24, child: CircularProgressIndicator()) : widget.icon,
      onPressed:
          isDisabled || widget.onTap == null
              ? null
              : (widget.onTap is Future<void> Function()
                  ? () async {
                    setState(() {
                      isDisabled = true;
                    });
                    try {
                      await widget.onTap!();
                    } finally {
                      if (mounted) {
                        setState(() {
                          isDisabled = false;
                        });
                      }
                    }
                  }
                  : widget.onTap),
    );
  }
}
