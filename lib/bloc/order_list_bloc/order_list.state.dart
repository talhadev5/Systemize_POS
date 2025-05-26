// bloc/order_state.dart
import 'package:equatable/equatable.dart';

import '../../data/models/order_list_model/order_list_model.dart' as OrderModel;


enum OrderStatus { initial, loading, success, error }

// order_list_state.dart
abstract class OrderListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderListInitial extends OrderListState {}

class OrderListLoading extends OrderListState {}

class OrderListLoaded extends OrderListState {
  final List<OrderModel.Data> orders;

  OrderListLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderListError extends OrderListState {
  final String message;

  OrderListError(this.message);

  @override
  List<Object?> get props => [message];
}
