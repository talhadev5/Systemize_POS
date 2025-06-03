// cart_bloc.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_event.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_state.dart' hide LoadOrderId;
import 'package:systemize_pos/data/models/cart_model/cart_model.dart';
import 'package:systemize_pos/data/models/hive_model/products_model.dart';
import 'package:systemize_pos/data/models/users/user_model.dart';
import 'package:systemize_pos/data/services/cart_services/cart_services.dart';
import 'package:systemize_pos/data/services/storage/local_storage.dart';
import 'package:web_socket_channel/io.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<UpdateItemQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<HoldCart>(_onHoldCart);
    on<LoadHeldCart>(_onLoadHeldCart);
    on<MoveHeldItemToCart>(_onMoveHeldItemToCart);
    on<ClearHeldCart>(_onClearHeldCart);
    on<SubmitCartOrder>(_onSubmitCartOrder);
    on<LoadOrderId>(_onLoadOrderId);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    final cartItems = await CartService.getCart();
    final prefs = await SharedPreferences.getInstance();
    final heldData = prefs.getStringList('heldCart') ?? [];

    final heldItems =
        heldData.map((json) => Items.fromJson(jsonDecode(json))).toList();
    emit(state.copyWith(cartItems: cartItems, heldItems: heldItems));
  }

  void _onAddItemToCart(AddItemToCart event, Emitter<CartState> emit) async {
    final updatedItems = List<Items>.from(state.cartItems);

    for (final newItem in event.item) {
      final index = updatedItems.indexWhere(
        (item) =>
            item.productId == newItem.productId &&
            _compareVariations(item.variation, newItem.variation) &&
            _addOnsEqual(item.addOns, newItem.addOns),
      );

      if (index != -1) {
        updatedItems[index].quantity += newItem.quantity;
        updatedItems[index].saleTax += newItem.saleTax;
        updatedItems[index].addOns.addAll(newItem.addOns);
      } else {
        updatedItems.add(newItem);
      }
    }

    await CartService.saveCart(updatedItems);
    emit(state.copyWith(cartItems: updatedItems));
  }

  void _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) async {
    final updatedItems =
        state.cartItems
            .where(
              (item) =>
                  item.productId != event.item.productId ||
                  !_compareVariations(item.variation, event.item.variation) ||
                  !_addOnsEqual(item.addOns, event.item.addOns),
            )
            .toList();
    await CartService.saveCart(updatedItems);
    emit(state.copyWith(cartItems: updatedItems));
  }

  void _onUpdateQuantity(
    UpdateItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    final updatedItems =
        state.cartItems.map((item) {
          if (item.productId == event.item.productId &&
              _compareVariations(item.variation, event.item.variation) &&
              _addOnsEqual(item.addOns, event.item.addOns)) {
            return item.copyWith(quantity: event.quantity);
          }
          return item;
        }).toList();

    await CartService.saveCart(updatedItems);
    emit(state.copyWith(cartItems: updatedItems));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    await CartService.saveCart([]);
    emit(state.copyWith(cartItems: []));
  }

  void _onHoldCart(HoldCart event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson =
        state.cartItems.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('heldCart', cartJson);
    await CartService.saveCart([]); // Clear cart from local
    emit(
      state.copyWith(
        cartItems: [],
        heldItems: [...state.heldItems, ...state.cartItems],
      ),
    );
  }

  void _onLoadHeldCart(LoadHeldCart event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final heldData = prefs.getStringList('heldCart') ?? [];
    final heldItems =
        heldData.map((json) => Items.fromJson(jsonDecode(json))).toList();
    emit(state.copyWith(heldItems: heldItems));
  }

  void _onMoveHeldItemToCart(
    MoveHeldItemToCart event,
    Emitter<CartState> emit,
  ) async {
    final heldItems = List<Items>.from(state.heldItems)..remove(event.item);
    final cartItems = List<Items>.from(state.cartItems)..add(event.item);

    final prefs = await SharedPreferences.getInstance();
    final heldJson = heldItems.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('heldCart', heldJson);

    await CartService.saveCart(cartItems);
    emit(state.copyWith(cartItems: cartItems, heldItems: heldItems));
  }

  void _onClearHeldCart(ClearHeldCart event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('heldCart');
    emit(state.copyWith(heldItems: []));
  }

  bool _compareVariations(Variation? v1, Variation? v2) {
    if (v1 == null && v2 == null) return true;
    if (v1 == null || v2 == null) return false;
    return v1.variationId == v2.variationId;
  }

  bool _addOnsEqual(List<AddOn> list1, List<AddOn> list2) {
    if (list1.length != list2.length) return false;
    for (var addOn in list1) {
      if (!list2.any((item) => item.addOnId == addOn.addOnId)) return false;
    }
    return true;
  }

  void _onLoadOrderId(LoadOrderId event, Emitter<CartState> emit) {
    emit(state.copyWith(loadedOrderId: event.orderId));
  }

  // submit order ............
  Future<void> _onSubmitCartOrder(
    SubmitCartOrder event,
    Emitter<CartState> emit,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final websocketUrl =
        prefs.getString('websocket_url') ?? 'ws://192.168.192.2:8765';
    String? uniqueId = prefs.getString('worker_unique_id');
    int? loadedOrderId = state.loadedOrderId;

    int? orderId;
    debugPrint("Loaded Order ID: $loadedOrderId and ${orderId.toString()}");
    debugPrint("..............Worket Id: $uniqueId  .................");
    debugPrint("..............websoket url: $websocketUrl .................");
    if (websocketUrl.isEmpty) {
      emit(
        CartSubmitFailure(
          'WebSocket URL not set. Please set it in Settings first.',
        ),
      );
      return;
    }
    emit(
      CartSubmitting(
        cartItems: List<Items>.from(state.cartItems),
        subTotal: state.subTotal,
        totalSaleTax: state.totalSaleTax,
        grandTotal: state.grandTotal,
      ),
    );

    try {
      debugPrint("Preparing order data...");

      final savedUserData = await LocalStorage.getData(key: 'user');
      int? userId;
      String? userName;

      if (savedUserData != null) {
        try {
          final userModel = UserModel.fromJson(jsonDecode(savedUserData));
          userId = userModel.userDetails?.id;
          userName = userModel.userDetails?.name;
        } catch (e) {
          debugPrint("Error parsing user data: $e");
        }
      }

      // Fetch additional data
      // String? orderType = prefs.getString('orderType');
      // String? waiter = prefs.getString('waiter');
      // String? table = prefs.getString('table');
      // String? customerName = prefs.getString('customerName');
      String? phone = prefs.getString('phone');
      String? address = prefs.getString('address');
      String? rider = prefs.getString('rider');
      // String? tableLocation = prefs.getString('selectedTableLocation');
      String? tableCapacity = prefs.getString('selectedTableCapacity');
      String? branchId = prefs.getString('branchId');

      String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
      String formattedDate = DateFormat(
        'dd-MM-yyyy HH:mm',
      ).format(DateTime.now());

      debugPrint('Cart contains ${state.cartItems.length} items.');

      if (loadedOrderId != null) {
        orderId =
            int.tryParse(loadedOrderId.toString()) ??
            int.parse(
              "${DateTime.now().year}${Random().nextInt(9999).toString().padLeft(4, '0')}",
            );
      } else {
        orderId = int.parse(
          "${DateTime.now().year}${Random().nextInt(9999).toString().padLeft(4, '0')}",
        );
      }
      // int orderId =
      //     event.orderId != null
      //         ? int.tryParse(event.orderId!) ??
      //             int.parse(
      //               "${DateTime.now().year}${Random().nextInt(9999).toString().padLeft(4, '0')}",
      //             )
      //         : int.parse(
      //           "${DateTime.now().year}${Random().nextInt(9999).toString().padLeft(4, '0')}",
      //         );
      Map<String, dynamic> data = {
        "reqType": "message",
        "to": "main",
        "from": uniqueId,
        "payload": {
          "info": {
            "phone": phone ?? "",
            "customerName": event.customerName,
            "address": address ?? "",
            "assignRider": rider ?? "",
            "waiter": userId ?? "",
            "table_no": event.tableNo ?? "",
            "table_id": event.tableNo ?? "",
            "table_location": event.tableNo ?? "",
            "type": event.orderType,
            "orderNote": event.orderNote,
            "customer_id": "",
            "table_capacity": tableCapacity ?? "",
            "waiterName": userName ?? '',
            "branch_id": branchId ?? "1",
          },
          "type": event.orderNote ?? "dineIn",
          "cartItems":
              state.cartItems.map((item) {
                Map<String, dynamic> variationJson =
                    item.variation?.toJson() ?? {};

                return {
                  "product_id": int.tryParse(item.productId) ?? 0,
                  "company_id": item.companyId ?? "1",
                  "branch_id": branchId ?? "1",
                  "category_id": item.categoryId ?? "",
                  "category": item.category ?? "",
                  "printer_ip": item.printerIp ?? "BIXOLON SRP-330III",
                  "kitchen_id": item.kitchenId ?? 0,
                  "kitchen_name": item.kitchenName ?? "",
                  "product_code": item.productCode ?? "",
                  "title": item.productName,
                  "product_image": '',
                  "favourite_item": "1",
                  "app_url": "https://adminpos.thewebconcept.com/",
                  "price": item.productPrice.toString(),
                  "created_at": DateTime.now().toIso8601String(),
                  "updated_at": DateTime.now().toIso8601String(),
                  "variations": item.variation != null ? [variationJson] : [],
                  "add_on": item.addOns.map((addOn) => addOn.toJson()).toList(),
                  "qty": item.quantity,
                  "additional_item": 0,
                  "product_variation":
                      item.variation != null ? [variationJson] : [],
                };
              }).toList(),
          "updatedOrderCartItems": [],
          "createdAt": int.parse(currentTime),
          "subTotal": state.subTotal,
          "screen": "confirmOrder",
          "status": "ready",
          "userId": userId,
          "checked": true,
          "split": 1,
          "splittedAmount": 0,
          "change": 0,
          "discount": 0,
          "serviceCharges": "",
          "saleTax": state.totalSaleTax,
          "finalTotal": state.grandTotal,
          "grandTotal": state.grandTotal,
          "isUploaded": 0,
          "credited_amount": 0,
          "updatedOrder": [],
          "orderHistory": loadedOrderId != null ? "updateAble" : "",
          "orderDateTime": formattedDate,
          "id": orderId,
        },
      };

      debugPrint("Connecting to WebSocket...");
      final channel = IOWebSocketChannel.connect(Uri.parse(websocketUrl));

      // channel.sink.add(jsonEncode(data));
      debugPrint("Order sent. Waiting for server response...");

      final orderJson = jsonEncode(data);

      // Send the order data
      channel.sink.add(orderJson);
      debugPrint('Order sent via WebSocket');
      add(ClearCart());
      // Optionally wait for a response
      final response = await channel.stream.first;
      debugPrint('WebSocket response: $response');

      if (response.contains('New order successfully added')) {
        await _clearSharedPreferences();
        add(ClearCart());
        emit(CartSubmitSuccess());
      } else {
        emit(CartSubmitFailure('Order failed: $response'));
      }
      // add(ClearCart());
    } catch (e) {
      debugPrint("WebSocket error: $e");
      // await channel.sink.close();
      emit(CartSubmitFailure('Failed to send order: ${e.toString()}'));
    }
  }

  Future<void> _clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('orderType');
    await prefs.remove('waiter');
    await prefs.remove('table');
    await prefs.remove('customerName');
    await prefs.remove('phone');
    await prefs.remove('address');
    await prefs.remove('rider');
    await prefs.remove('selectedTableLocation');
    await prefs.remove('selectedTableCapacity');
  }
}
