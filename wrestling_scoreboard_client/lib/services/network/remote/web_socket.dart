import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wrestling_scoreboard_client/services/network/data_manager.dart';
import 'package:wrestling_scoreboard_client/services/network/remote/url.dart';
import 'package:wrestling_scoreboard_client/view/utils.dart';
import 'package:wrestling_scoreboard_common/common.dart';

final _logger = Logger('WebSocketManager');

enum WebSocketConnectionState { connecting, connected, disconnecting, disconnected }

/// Close event codes: https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent/code
/// Custom:
/// - 4210: Client attempts to reconnect
class WebSocketManager {
  final DataManager dataManager;
  WebSocketChannel? _channel;
  StreamSubscription<Object?>? _channelSubscription;
  String? _wsUrl;

  /// Count retries, after the websocket disconnects.
  int _retryCount = 0;

  /// Save current retry timer. Only one can run at the same time.
  Timer? _retryTimer;

  /// Manages connection state of WebSocket
  final StreamController<WebSocketConnectionState> onWebSocketConnection = StreamController.broadcast();

  WebSocketManager(this.dataManager, {String? url}) {
    Future<int> handleSingle<T extends DataObject>({required CRUD operation, required T single}) async {
      if (operation == CRUD.update) {
        dataManager.getSingleStreamController<T>()?.sink.add(single);
      }
      return single.id!;
    }

    Future<int> handleSingleRaw<T extends DataObject>({
      required CRUD operation,
      required Map<String, dynamic> single,
    }) async {
      if (operation == CRUD.update) {
        dataManager.getSingleRawStreamController<T>()?.sink.add(single);
      }
      return single['id'];
    }

    Future<void> handleMany<T extends DataObject>({required CRUD operation, required ManyDataObject<T> many}) async {
      final tmp = ManyDataObject<T>(data: many.data, filterId: many.filterId, filterType: many.filterType);
      final filterType = many.filterType;
      dataManager.getManyStreamController<T>(filterType: filterType)?.sink.add(tmp);
    }

    Future<void> handleManyRaw<T extends DataObject>({
      required CRUD operation,
      required ManyDataObject<Map<String, dynamic>> many,
    }) async {
      final tmp = ManyDataObject<Map<String, dynamic>>(
        data: many.data,
        filterId: many.filterId,
        filterType: many.filterType,
      );
      final filterType = many.filterType;
      dataManager.getManyRawStreamController<T>(filterType: filterType)?.sink.add(tmp);
    }

    messageHandler(dynamic message) {
      final json = jsonDecode(message);
      handleGenericJson(
        json,
        handleSingle: handleSingle,
        handleMany: handleMany,
        handleSingleRaw: handleSingleRaw,
        handleManyRaw: handleManyRaw,
      );
    }

    if (url != null) {
      _wsUrl = adaptLocalhost(url);
    }
    onWebSocketConnection.stream.listen((connectionState) async {
      if (connectionState == WebSocketConnectionState.connecting && _wsUrl != null) {
        // Close previous session, if existent.
        // Also cancel subscription immediately to not have conflicting events with newly created channel.
        _channelSubscription?.cancel();
        await _channel?.sink.close(4210, 'Reconnecting websocket connection.');
        try {
          _channel = WebSocketChannel.connect(Uri.parse(_wsUrl!));
          _channelSubscription = _channel?.stream.listen(
            messageHandler,
            onError: (e) {
              if (e is WebSocketChannelException) {
                _logger.warning('Websocket connection refused by server');
                onWebSocketConnection.sink.add(WebSocketConnectionState.disconnecting);
              }
            },
            onDone: () {
              // Stream is done, can cancel subscription.
              _channelSubscription?.cancel();
              _channelSubscription = null;
              if (_channel?.closeCode == 4210) {
                _logger.info('Websocket connection reconnecting: ${_channel?.closeReason}');
                onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);
              } else if (_channel?.closeCode == 1001) {
                _logger.info('Websocket connection closed by client ${_channel?.closeReason}');
                onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);
              } else if (_channel?.closeCode == null) {
                // E.g.
                // - was not yet connected
                // - server is already shut down
                // - no internet
                // - refusing the connection
                _logger.info(
                  'Websocket connection could not be established or was closed by server without close code',
                );
                // Avoid overriding previous SocketException when setting a disconnected state

                _retryConnecting();
              } else {
                // E.g.
                // - already connected
                // - server is shutting down
                _logger.info(
                  'Websocket connection closed by server (Code: ${_channel?.closeCode}, Reason: ${_channel?.closeReason})',
                );
                onWebSocketConnection.sink.add(WebSocketConnectionState.disconnected);

                _retryConnecting();
              }
              _channel = null;
            },
          );
          await _channel?.ready.timeout(const Duration(seconds: 5));
          _logger.fine('Websocket connection established: $_wsUrl');
          onWebSocketConnection.sink.add(WebSocketConnectionState.connected);
          // Reset retry count
          _retryCount = 0;
          // Send authentication token, if signed in.
          if (dataManager.authService != null) {
            addToSink(jsonEncode(dataManager.authService?.header));
          }
        } on SocketException catch (e) {
          // Thrown, when connection failed, waiting for `ready` state.
          _logger.warning('Websocket connection refused by server: $e');
          onWebSocketConnection.sink.addError(e);
        }
      } else if (connectionState == WebSocketConnectionState.disconnecting) {
        // Subscription is canceled and stream state is set to disconnected in `onDone` listener.
        await _channel?.sink.close(1001);
      }
    });
    onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
  }

  void addToSink(String val) {
    _channel?.sink.add(val);
  }

  /// Retry regularly when disconnecting.
  void _retryConnecting() {
    // Do not retry multiple times in the same period.
    if (_retryTimer != null) return;
    final duration = getRetryDuration(_retryCount);
    if (duration == null) return;
    _retryTimer = Timer(duration, () {
      onWebSocketConnection.sink.add(WebSocketConnectionState.connecting);
      _retryTimer = null;
    });
    _retryCount++;
  }
}
