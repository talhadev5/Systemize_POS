// websocket_bloc.dart
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemize_pos/bloc/soket_connection/soket_con_event.dart';
import 'package:systemize_pos/bloc/soket_connection/soket_con_state.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketConnBloc extends Bloc<WebSocketConnEvent, WebSocketConnState> {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  bool _isConnected = false;

  WebSocketConnBloc() : super(WebSocketInitial()) {
    on<ConnectWebSocket>(_onConnect);
    on<DisconnectWebSocket>(_onDisconnect);
    on<WebSocketMessageReceived>(_onMessageReceived);

    add(ConnectWebSocket('ws://192.168.192.2:8765'));
  }

  Future<void> _onConnect(
    ConnectWebSocket event,
    Emitter<WebSocketConnState> emit,
  ) async {
    if (_isConnected) return; // prevent duplicate connection
    emit(WebSocketConnecting());

    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(event.url));
      _subscription = _channel!.stream.listen(
        (message) {
          _isConnected = true;
          add(WebSocketMessageReceived(message));
          debugPrint('WebSocket message received: $message');
        },
        onDone: () {
          _isConnected = false;
          debugPrint('WebSocket connection closed.');
          add(DisconnectWebSocket());
        },
        onError: (error) {
          _isConnected = false;
          debugPrint('WebSocket connection error: $error');
          add(WebSocketMessageReceived("error: $error"));
        },
      );

      // Wait briefly to ensure connection is established
      // await Future.delayed(Duration(milliseconds: 300));

      // // Generate unique ID (replace this with your own strategy if needed)
      // String uniqueId =
      //     "worker-${DateTime.now().millisecondsSinceEpoch % 10000}";
      // log(uniqueId);
      // Retrieve or generate unique ID
      final prefs = await SharedPreferences.getInstance();
      String? uniqueId = prefs.getString('worker_unique_id');

      if (uniqueId == null) {
        uniqueId = "worker-${DateTime.now().millisecondsSinceEpoch % 10000}";
        await prefs.setString('worker_unique_id', uniqueId);
        log("New ID generated and stored: $uniqueId");
      } else {
        log("Using stored ID: $uniqueId");
      }
      // Send registration message
      _channel!.sink.add(
        jsonEncode({"reqType": "register", "role": "worker", "id": uniqueId}),
      );

      // Optionally send a "hi" message after registration
      debugPrint('WebSocket connected: ${event.url}');
    } catch (e) {
      emit(WebSocketError(e.toString()));
    }
  }

  void _onDisconnect(
    DisconnectWebSocket event,
    Emitter<WebSocketConnState> emit,
  ) {
    _subscription?.cancel();
    _channel?.sink.close();
    _isConnected = false;
    emit(WebSocketDisconnected());
  }

  void _onMessageReceived(
    WebSocketMessageReceived event,
    Emitter<WebSocketConnState> emit,
  ) {
    // You can handle special messages here if needed
    emit(WebSocketConnected(event.message));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _channel?.sink.close();
    return super.close();
  }
}
