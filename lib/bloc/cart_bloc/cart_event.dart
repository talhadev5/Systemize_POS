// cart_event.dart
import 'package:systemize_pos/data/models/cart_model/cart_model.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddItemToCart extends CartEvent {
  final List<Items> item;
  AddItemToCart(this.item);
}

class RemoveItemFromCart extends CartEvent {
  final Items item;
  RemoveItemFromCart(this.item);
}

class UpdateItemQuantity extends CartEvent {
  final Items item;
  final int quantity;
  UpdateItemQuantity(this.item, this.quantity);
}

class ClearCart extends CartEvent {}

class HoldCart extends CartEvent {}

class MoveHeldItemToCart extends CartEvent {
  final Items item;
  MoveHeldItemToCart(this.item);
}

class LoadHeldCart extends CartEvent {}

class ClearHeldCart extends CartEvent {}

class SubmitCartOrder extends CartEvent {
  final String? orderId;
  final bool? isNewOrder;
  final String? customerName;
  final String? orderNote;
  final String? orderType;
  final String? tableNo;

  SubmitCartOrder({
    this.orderId,
    this.isNewOrder = false,
    this.customerName,
    this.orderNote,
    this.orderType,
    this.tableNo,
  });
}

class LoadOrderId extends CartEvent {
  final int orderId;
  LoadOrderId(this.orderId);

}
class UpdateOrderType extends CartEvent {
  final String orderType;
  UpdateOrderType(this.orderType);
}