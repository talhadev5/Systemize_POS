// cart_bloc.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_event.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_state.dart';
import 'package:systemize_pos/data/models/cart_model/cart_model.dart';
import 'package:systemize_pos/data/models/hive_model/products_model.dart';
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
    on<SubmitCartOrderWithDetails>(_onSubmitDetails);
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
    final index = updatedItems.indexWhere(
      (item) =>
          item.productId == event.item.productId &&
          _compareVariations(item.variation, event.item.variation) &&
          _addOnsEqual(item.addOns, event.item.addOns),
    );

    if (index != -1) {
      updatedItems[index].quantity += event.item.quantity;
      updatedItems[index].saleTax += event.item.saleTax;
      updatedItems[index].addOns.addAll(event.item.addOns);
    } else {
      updatedItems.add(event.item);
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

  // submit order ............
  Future<void> _onSubmitCartOrder(
    SubmitCartOrder event,
    Emitter<CartState> emit,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final websocketUrl = prefs.getString('websocket_url');

    if (websocketUrl == null || websocketUrl.isEmpty) {
      debugPrint(
        "..............websoket error: $websocketUrl .................",
      );
      emit(
        CartSubmitFailure(
          'WebSocket URL not set. Please set it in Settings first.',
        ),
      );
      return;
    }
    debugPrint("...............................");
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

      String? userIdStr = await LocalStorage.getData(key: 'userId');
      int? userId = userIdStr != null ? int.tryParse(userIdStr) : null;

      // Fetch additional data
      String? orderType = prefs.getString('orderType');
      String? waiter = prefs.getString('waiter');
      String? table = prefs.getString('table');
      String? customerName = prefs.getString('customerName');
      String? phone = prefs.getString('phone');
      String? address = prefs.getString('address');
      String? rider = prefs.getString('rider');
      String? tableLocation = prefs.getString('selectedTableLocation');
      String? tableCapacity = prefs.getString('selectedTableCapacity');
      String? branchId = prefs.getString('branchId');

      String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
      String formattedDate = DateFormat(
        'dd-MM-yyyy HH:mm',
      ).format(DateTime.now());

      debugPrint('Cart contains ${state.cartItems.length} items.');

      // List<Map<String, dynamic>> cartItemsData =
      //     state.cartItems.map((item) {
      //       return {
      //         "qty": item.quantity,
      //         "price": item.productPrice.toString(),
      //         "title": item.productName,
      //         "add_on": item.addOns.map((addOn) => addOn.toJson()).toList(),
      //         "variations":
      //             item.variation != null ? [item.variation!.toJson()] : [],
      //         "product_id": item.productId,
      //         "category": item.category,
      //         "product_variation": item.variation?.toJson(),
      //         "additional_item": 0,
      //         "app_url": "https://adminpos.thewebconcept.com/",
      //         "branch_id": branchId ?? "",
      //         "category_id": item.categoryId ?? "",
      //         "company_id": item.companyId ?? "",
      //         "created_at": DateTime.now().toIso8601String(),
      //         "favourite_item": "0",
      //         "kitchen_id": item.kitchenId ?? "",
      //         "kitchen_name": item.kitchenName ?? "",
      //         "printer_ip": item.printerIp ?? "BIXOLON SRP-330III",
      //         "product_code": item.productCode ?? "",
      //         "product_image": "",
      //         "updated_at": DateTime.now().toIso8601String(),
      //       };
      //     }).toList();

      // debugPrint(
      //   "Cart Items JSON:\n${JsonEncoder.withIndent('  ').convert(cartItemsData)}",
      // );

      String orderId =
          event.orderId ??
          "${DateTime.now().year}${Random().nextInt(9999).toString().padLeft(4, '0')}";

      Map<String, dynamic> data = {
        "info": {
          "phone": phone ?? "",
          "customerName": state.customerName,
          "address": address ?? "",
          "assignRider": rider ?? "",
          "waiter": waiter ?? "",
          "table_no": table ?? "",
          "table_id": "",
          "table_location": tableLocation ?? "",
          "type": state.orderType,
          "orderNote": state.orderNote,
          "customer_id": "",
          "table_capacity": tableCapacity ?? "",
          "waiterName": "",
          "branch_id": branchId ?? "1",
        },
        "type": orderType ?? "dineIn",
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
        "userId": 2,
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
        "orderHistory": "",
        "orderDateTime": formattedDate,
        "id": int.parse(orderId),
      };
      // debugPrint(
      //   "Cart Items JSON:\n${JsonEncoder.withIndent('  ').convert(data)}",
      // );
      debugPrint("Connecting to WebSocket...");
      final channel = IOWebSocketChannel.connect(
        Uri.parse('ws://192.168.192.18:8765'),
      );

      // channel.sink.add(jsonEncode(data));
      debugPrint("Order sent. Waiting for server response...");

      final orderJson = jsonEncode(data);

      // Send the order data
      channel.sink.add(orderJson);
      debugPrint('Order sent via WebSocket');

      // Optionally wait for a response
      final response = await channel.stream.first;
      debugPrint('WebSocket response: $response');

      await channel.sink.close();
      debugPrint("WebSocket closed.");

      // Clear SharedPreferences after success
      await _clearSharedPreferences();
      debugPrint("SharedPreferences cleared.");
      add(ClearCart());

      emit(CartSubmitSuccess());
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

  //  order details.............
  void _onSubmitDetails(
    SubmitCartOrderWithDetails event,
    Emitter<CartState> emit,
  ) {
    emit(
      state.copyWith(
        customerName: event.customerName,
        orderNote: event.orderNote,
        orderType: event.orderType,
      ),
    );
  }
}
