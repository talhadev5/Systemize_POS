import 'package:systemize_pos/data/models/hive_model/products_model.dart';

class ProductDetailState {
  final List<Variation> selectedVariations;
  final List<AddOn> selectedAddOns;

  const ProductDetailState({
    this.selectedVariations = const [],
    this.selectedAddOns = const [],
  });

  ProductDetailState copyWith({
    List<Variation>? selectedVariations,
    List<AddOn>? selectedAddOns,
  }) {
    return ProductDetailState(
      selectedVariations: selectedVariations ?? this.selectedVariations,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
    
    );
  }
  List<Object?> get props => [selectedVariations, selectedAddOns];
}
