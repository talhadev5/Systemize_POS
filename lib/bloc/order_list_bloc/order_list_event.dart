// bloc/order_event.dart
import 'package:equatable/equatable.dart';


abstract class OrderListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchOrders extends OrderListEvent {}
class ToggleSearch extends OrderListEvent  {}

class UpdateSearchQuery extends OrderListEvent  {
  final String query;
  UpdateSearchQuery(this.query);
}

class HideSearchBar extends OrderListEvent {}