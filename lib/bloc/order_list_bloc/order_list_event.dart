// bloc/order_event.dart
import 'package:equatable/equatable.dart';


abstract class OrderListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchOrders extends OrderListEvent {}
