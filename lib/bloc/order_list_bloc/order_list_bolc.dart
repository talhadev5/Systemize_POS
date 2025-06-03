// bloc/order_bloc.dart
import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/order_list_bloc/order_list.state.dart';
import 'package:systemize_pos/bloc/order_list_bloc/order_list_event.dart';
import 'package:systemize_pos/data/models/order_list_model/order_list_model.dart';
import 'package:systemize_pos/data/repositories/order_list_repo/order_list_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

// order_list_bloc.dart
import 'package:bloc/bloc.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final OrderRepository repository;
  List<Data> _allOrders = [];

  OrderListBloc({required this.repository}) : super(OrderListInitial()) {
    on<FetchOrders>(_onFetchOrders);
       on<ToggleSearch>(_onToggleSearch);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<HideSearchBar>(_onHideSearchBar);
  }

  // Separated function to handle FetchOrders event
  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<OrderListState> emit,
  ) async {
    emit(OrderListLoading());
   try {
  final orderListModel = await repository.fetchOrders();
  log('Fetched orders: ${orderListModel.data}');
  final List<Data> orders = List<Data>.from(orderListModel.data??[]);
   _allOrders = orders;
  emit(OrderListLoaded(orders));
} catch (e) {
  log('Error fetching orders: $e');
  emit(OrderListError(e.toString()));
}
  }
 void _onToggleSearch(ToggleSearch event, Emitter<OrderListState> emit) {
    emit(SearchVisible());
  }

  void _onUpdateSearchQuery(UpdateSearchQuery event, Emitter<OrderListState> emit) {
    final filteredOrders = _allOrders
        .where((order) =>
            order.info?.customerName?.toLowerCase().contains(event.query.toLowerCase()) ?? false)
        .toList();
    emit(OrderListLoaded(filteredOrders));
  }

  void _onHideSearchBar(HideSearchBar event, Emitter<OrderListState> emit) {
    emit(SearchHidden());
    emit(OrderListLoaded(_allOrders));
  }



}
