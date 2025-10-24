import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/local_preferences_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/exception.dart';

class LoadingBuilder<T> extends ConsumerWidget {
  final Future<T> future;
  final T? initialData;
  final void Function()? onRetry;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context, Object? exception, {StackTrace? stackTrace})? onException;
  final Widget Function(BuildContext context)? onLoad;

  const LoadingBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.onException,
    this.onLoad,
    this.initialData,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<T>(
      future: ref
          .read(networkTimeoutProvider)
          .then(
            (timeout) => future.timeout(
              timeout,
              onTimeout:
                  () =>
                      throw TimeoutException('LoadingBuilder could not load $T and initialData $initialData', timeout),
            ),
          ),
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return onException?.call(context, snapshot.error!, stackTrace: snapshot.stackTrace) ??
              ExceptionCard(snapshot.error!, stackTrace: snapshot.stackTrace, onRetry: onRetry);
        }
        if (initialData != null) {
          return builder(context, initialData as T);
        }
        if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
          return onLoad?.call(context) ?? const Center(child: CircularProgressIndicator());
        }
        return builder(context, snapshot.data as T);
      },
    );
  }
}

class LoadingStreamBuilder<T> extends StatelessWidget {
  final T? initialData;
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) builder;
  final void Function() onRetry;

  const LoadingStreamBuilder({
    super.key,
    this.initialData,
    required this.builder,
    required this.stream,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return ExceptionCard(snapshot.error!, onRetry: onRetry, stackTrace: snapshot.stackTrace);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return builder(context, snapshot.data as T);
      },
    );
  }
}
