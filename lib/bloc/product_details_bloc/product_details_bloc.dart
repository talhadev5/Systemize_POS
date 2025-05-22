import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/product_details_bloc/product_details_state.dart';
import 'package:systemize_pos/data/models/hive_model/products_model.dart';

import 'product_deatils_event.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(const ProductDetailState()) {
    on<SelectVariationEvent>(_onSelectVariation);
    on<ToggleAddOnEvent>(_onToggleAddOn);
    on<ClearSelectionsEvent>(_onClearSelections);
  }

  // Handle variation selection (single selection)
  void _onSelectVariation(
    SelectVariationEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(selectedVariations: [event.variation]));
  }

  // Handle add-on toggle (multi-select)
  void _onToggleAddOn(
    ToggleAddOnEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    final updatedAddOns = List<AddOn>.from(state.selectedAddOns);
    if (updatedAddOns.contains(event.addOn)) {
      updatedAddOns.remove(event.addOn);
    } else {
      updatedAddOns.add(event.addOn);
    }
    emit(state.copyWith(selectedAddOns: updatedAddOns));
  }

  // Clear all selections
  void _onClearSelections(
    ClearSelectionsEvent event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(const ProductDetailState());
  }
}

