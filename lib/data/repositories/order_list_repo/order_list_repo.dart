// repositories/order_repository.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemize_pos/data/models/order_list_model/order_list_model.dart';
import 'package:systemize_pos/data/models/users/user_model.dart';
import 'package:systemize_pos/data/services/storage/local_storage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// class OrderRepository {
//   Future<OrderListModel> fetchOrders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final websocketUrl =
//         prefs.getString('websocket_url') ?? 'ws://192.168.192.2:8765';

//     final completer = Completer<OrderListModel>();

//     try {
//       // String? token = '';
//       int? userId = 40;

//       final channel = IOWebSocketChannel.connect(Uri.parse(websocketUrl));

//       final request = {
//         "reqType": "message",
//         "to": "main",
//         "from": "7550",
//         "payload": {"reqType": "request_orders", "userId": userId},
//       };

//       channel.sink.add(jsonEncode(request));
//       debugPrint('Sent request: ${jsonEncode(request)}');
//       // channel.stream.listen(
//       //   (message) {
//       //     final response = jsonDecode(message);
//       //     debugPrint('Received response: $message');
//       //     if (response['from'] == 'registered') {
//       //       final ordersData = response['orders'];
//       //       final orderListModel = OrderListModel.fromJson(ordersData);
//       //       completer.complete(orderListModel);
//       //       channel.sink.close();
//       //     }
//       //   },
//       //   onError: (error) {
//       //     debugPrint('WebSocket error: $error');
//       //     completer.completeError('WebSocket error: $error');
//       //     channel.sink.close();
//       //   },
//       //   onDone: () {
//       //     if (!completer.isCompleted) {
//       //       completer.completeError('WebSocket closed before response');
//       //     }
//       //   },
//       // );
//       channel.stream.listen(
//         (message) {
//           debugPrint('🟢 Raw WebSocket Message: $message');
//           final response = jsonDecode(message);

//           if (response['from'] == 'main' && response['payload'] != null) {
//             final ordersData = response['payload'];
//             debugPrint('Decoded Payload: $ordersData');

//             try {
//               final orderListModel = OrderListModel.fromJson(ordersData);
//               completer.complete(orderListModel);
//             } catch (e) {
//               debugPrint('Error parsing orders: $e');
//               completer.completeError('Failed to parse orders');
//             }

//             channel.sink.close();
//           }
//         },
//         onError: (error) {
//           debugPrint('WebSocket error: $error');
//           completer.completeError('WebSocket error: $error');
//           channel.sink.close();
//         },
//         onDone: () {
//           if (!completer.isCompleted) {
//             completer.completeError('WebSocket closed before response');
//           }
//         },
//       );

//       return completer.future;
//     } catch (e) {
//       debugPrint('Error fetching orders: $e');
//       throw Exception('Failed to load orders: $e');
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
// Update path as per your project

class OrderRepository {
  Future<OrderListModel> fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final websocketUrl =
        prefs.getString('websocket_url') ?? 'ws://192.168.192.2:8765';

    final completer = Completer<OrderListModel>();

    try {
      // int? userId = 40;
      final savedUserData = await LocalStorage.getData(key: 'user');
      int? userId;
      // String? userName;

      if (savedUserData != null) {
        try {
          final userModel = UserModel.fromJson(jsonDecode(savedUserData));
          userId = userModel.userDetails?.id;
          // userName = userModel.userDetails?.name;
        } catch (e) {
          debugPrint("Error parsing user data: $e");
        }
      }
      final prefs = await SharedPreferences.getInstance();
      String? uniqueId = prefs.getString('worker_unique_id');
      debugPrint('get worker id...........$uniqueId');
      debugPrint("📡 Connecting to WebSocket: $websocketUrl");

      final channel = IOWebSocketChannel.connect(
        Uri.parse(websocketUrl),
        connectTimeout: const Duration(seconds: 5),
      );
      final registerRequest = {
        "reqType": "register",
        "role": "worker",
        "id": uniqueId,
      };
      debugPrint("📝 Sending register request: ${jsonEncode(registerRequest)}");
      channel.sink.add(jsonEncode(registerRequest));

      // channel.stream.listen(
      //   (message) {
      //     debugPrint('🟢 Received: $message');

      //     try {
      //       final response = jsonDecode(message);

      //       final request = {
      //         "reqType": "message",
      //         "to": "main",
      //         "from": "worker-3207",
      //         "payload": {"reqType": "request_orders", "userId": userId},
      //       };
      //       debugPrint('📤 Sending request: ${jsonEncode(request)}');
      //       channel.sink.add(jsonEncode(request));
      //       if (response['from'] == 'main' && response['payload'] != null) {
      //         final ordersData = response['payload'];
      //         final orderListModel = OrderListModel.fromJson(ordersData);
      //         completer.complete(orderListModel);
      //       } else {
      //         debugPrint('⚠️ Invalid response format or source');
      //         completer.complete(OrderListModel());
      //       }
      //     } catch (e) {
      //       debugPrint('❌ Error decoding response: $e');
      //       completer.complete(OrderListModel());
      //     } finally {
      //       channel.sink.close(status.normalClosure);
      //     }
      //   },
      //   onError: (error) {
      //     debugPrint('❌ WebSocket error: $error');
      //     if (!completer.isCompleted) {
      //       completer.complete(OrderListModel());
      //     }
      //     channel.sink.close(status.goingAway);
      //   },
      //   onDone: () {
      //     debugPrint('⚠️ WebSocket connection closed');
      //     if (!completer.isCompleted) {
      //       completer.complete(OrderListModel());
      //     }
      //   },
      // );
      channel.stream.listen(
        (message) {
          debugPrint('🟢 Received: $message');
          final response = jsonDecode(message);

          if (response['reqType'] == 'registered') {
            // Now send the order request
            final request = {
              "reqType": "message",
              "to": "main",
              "from": uniqueId,
              "payload": {"reqType": "request_orders", "userId": userId},
            };
            debugPrint('📤 Sending request: ${jsonEncode(request)}');
            channel.sink.add(jsonEncode(request));
          }
          if (response['from'] == 'main' && response['payload'] != null) {
            final payload = response['payload'];
            if (payload.containsKey('orders')) {
              final ordersData = payload['orders'];
              final orderListModel = OrderListModel.fromJson({
                'orders': ordersData,
              });
              if (!completer.isCompleted) {
                completer.complete(orderListModel);
              }
            } else {
              debugPrint('⚠️ "orders" key not found in payload: $payload');
              if (!completer.isCompleted) {
                completer.complete(OrderListModel());
              }
            }
            channel.sink.close();
          }
        },
        onError: (error) {
          debugPrint('❌ WebSocket error: $error');
          if (!completer.isCompleted) {
            completer.complete(OrderListModel());
          }
          channel.sink.close(1000);
        },
        onDone: () {
          debugPrint('⚠️ WebSocket connection closed');
          if (!completer.isCompleted) {
            completer.complete(OrderListModel());
          }
        },
      );

      return completer.future;
    } catch (e) {
      debugPrint('❌ Exception: $e');
      return OrderListModel();
    }
  }
}
