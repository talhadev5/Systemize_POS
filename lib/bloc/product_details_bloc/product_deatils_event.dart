import 'package:systemize_pos/data/models/hive_model/products_model.dart';

abstract class ProductDetailEvent {
  const ProductDetailEvent();

  
}

class SelectVariationEvent extends ProductDetailEvent {
  final Variation variation;
  SelectVariationEvent(this.variation);
}

class ToggleAddOnEvent extends ProductDetailEvent {
  final AddOn addOn;
  ToggleAddOnEvent(this.addOn);
}

class ClearSelectionsEvent extends ProductDetailEvent {}
