// cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:systemize_pos/data/models/cart_model/cart_model.dart';

class CartState extends Equatable {
  final List<Items> cartItems;
  final List<Items> heldItems;

  const CartState({
    this.cartItems = const [],
    this.heldItems = const [],
  });

  double get grandTotal => cartItems.fold(0, (sum, item) => sum + item.total);
  double get subTotal => cartItems.fold(0, (sum, item) => sum + item.subtotal);
  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalSaleTax => cartItems.fold(0, (sum, item) => sum + item.saleTax);

  CartState copyWith({
    List<Items>? cartItems,
    List<Items>? heldItems,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      heldItems: heldItems ?? this.heldItems,
    );
  }
  
  @override

  List<Object?> get props => [cartItems, heldItems];
}
class CartInitial extends CartState {}

class CartSubmitting extends CartState {}

class CartSubmitSuccess extends CartState {}

class CartSubmitFailure extends CartState {
  final String message;

  const CartSubmitFailure(this.message);

}