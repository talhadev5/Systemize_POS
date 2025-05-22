import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object> get props => [];
}

class LoadData extends ProductEvent {}

class UpdateSearchQuery extends ProductEvent {
  final String query;
  const UpdateSearchQuery(this.query);
  @override
  List<Object> get props => [query];
}

class SelectCategory extends ProductEvent {
  final String category;
  const SelectCategory(this.category);
  @override
  List<Object> get props => [category];
}

class ToggleView extends ProductEvent {}

class ProductApi extends ProductEvent {
  final bool forceRefresh;
  const ProductApi({this.forceRefresh = false});
  @override
  List<Object> get props => [forceRefresh];
}

class TapProduct extends ProductEvent {
  final int? index;
  const TapProduct({this.index});
  @override
  List<Object> get props => [index!];
}
