// repositories/order_repository.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemize_pos/data/models/order_list_model/order_list_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OrderRepository {
  Future<OrderListModel> fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final websocketUrl =
        prefs.getString('websocket_url') ?? 'ws://192.168.192.2:8765';

    final completer = Completer<OrderListModel>();

    try {
      // String? token = '';
      int? userId = 40;

      final channel = IOWebSocketChannel.connect(Uri.parse(websocketUrl));

      final request = {"type": "request_orders", "userId": userId??''};

      channel.sink.add(jsonEncode(request));
  debugPrint('Sent request: ${jsonEncode(request)}');
      channel.stream.listen(
        (message) {
          final response = jsonDecode(message);
debugPrint('Received response: $message');
          if (response['type'] == 'orders_response') {
            final ordersData = response['orders'];
            final orderListModel = OrderListModel.fromJson(ordersData);
            completer.complete(orderListModel);
            channel.sink.close();
          }
        },
        onError: (error) {
            debugPrint('WebSocket error: $error');
          completer.completeError('WebSocket error: $error');
          channel.sink.close();
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.completeError('WebSocket closed before response');
          }
        },
      );

      return completer.future;
    } catch (e) {
       debugPrint('Error fetching orders: $e');
      throw Exception('Failed to load orders: $e');
    }
  }
}
