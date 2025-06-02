// cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:systemize_pos/data/models/cart_model/cart_model.dart';

class CartState extends Equatable {
  final List<Items> cartItems;
  final List<Items> heldItems;
  final String customerName;
  final String orderNote;
  final String orderType;
  final int? loadedOrderId;

  const CartState({
    this.cartItems = const [],
    this.heldItems = const [],
    this.customerName = '',
    this.orderNote = '',
    this.orderType = '',
    this.loadedOrderId,
  });

  double get grandTotal => cartItems.fold(0, (sum, item) => sum + item.total);
  double get subTotal => cartItems.fold(0, (sum, item) => sum + item.subtotal);
  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalSaleTax =>
      cartItems.fold(0, (sum, item) => sum + item.saleTax);

  CartState copyWith({
    List<Items>? cartItems,
    List<Items>? heldItems,
    String? customerName,
    String? orderNote,
    String? orderType,
    int? loadedOrderId,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      heldItems: heldItems ?? this.heldItems,
      customerName: customerName ?? this.customerName,
      orderNote: orderNote ?? this.orderNote,
      orderType: orderType ?? this.orderType,
      loadedOrderId: loadedOrderId ?? this.loadedOrderId,
    );
  }

  @override
  List<Object?> get props => [
    cartItems,
    heldItems,
    customerName,
    orderNote,
    orderType,
    loadedOrderId,
  ];
}

class CartInitial extends CartState {}

class CartSubmitting extends CartState {
  const CartSubmitting({
    required super.cartItems,
    required double subTotal,
    required double totalSaleTax,
    required double grandTotal,
  }) : _subTotal = subTotal,
       _totalSaleTax = totalSaleTax,
       _grandTotal = grandTotal;

  final double _subTotal;
  final double _totalSaleTax;
  final double _grandTotal;

  @override
  double get subTotal => _subTotal;

  @override
  double get totalSaleTax => _totalSaleTax;

  @override
  double get grandTotal => _grandTotal;

  @override
  List<Object?> get props => [cartItems, _subTotal, _totalSaleTax, _grandTotal];
}

class CartSubmitSuccess extends CartState {}

class CartSubmitFailure extends CartState {
  final String message;

  const CartSubmitFailure(this.message);
}
