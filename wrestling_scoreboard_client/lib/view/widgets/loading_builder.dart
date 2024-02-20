import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/view/widgets/exception.dart';

class LoadingBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final T? initialData;
  final void Function()? onRetry;
  final Widget Function(BuildContext context, T data) builder;

  const LoadingBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.initialData,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return ExceptionWidget(snapshot.error!, onRetry: onRetry);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (initialData != null) {
          return builder(context, initialData as T);
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
          return ExceptionWidget(snapshot.error!, onRetry: onRetry);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return builder(context, snapshot.data as T);
      },
    );
  }
}
