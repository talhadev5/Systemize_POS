// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_bloc.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_event.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_state.dart';
import 'package:systemize_pos/bloc/product_details_bloc/product_deatils_event.dart';
import 'package:systemize_pos/bloc/product_details_bloc/product_details_bloc.dart';
import 'package:systemize_pos/bloc/product_details_bloc/product_details_state.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/widgets/custom_sankbar.dart';
import 'package:systemize_pos/data/models/cart_model/cart_model.dart';
import 'package:systemize_pos/data/models/hive_model/products_model.dart';
import 'package:systemize_pos/utils/app_url.dart';
import 'package:systemize_pos/utils/extensions/media_query_extensions.dart';
import 'package:systemize_pos/utils/extensions/string_extension.dart';

class ProductDetailSheet extends StatefulWidget {
  final Product product;
  final BuildContext rootContext;

  const ProductDetailSheet({
    super.key,
    required this.product,
    required this.rootContext,
    s,
  });

  @override
  State<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<ProductDetailSheet> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.screenHeight * .01),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(
                  6,
                ), // Adjust for spacing around the icon
                decoration: BoxDecoration(
                  color: Colors.red, // Background color
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 20, // Smaller icon size
                  color: Colors.white, // Icon color
                ),
              ),
            ),
          ),
          SizedBox(height: context.screenHeight * .01),

          /// --- Product Image ---
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl:
                  product.productImage != null &&
                          product.productImage!.isNotEmpty
                      ? '$filesBaseUrl/${product.productImage}'
                      : 'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=400&q=80',

              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),

          SizedBox(height: context.screenHeight * .025),

          /// --- Product Info ---
          Text(
            product.title.toString().capitalizeEachWord(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Category: ${product.category.toString().capitalizeEachWord()}",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            "Rs. ${product.price}",
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.customThemeColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Divider(height: 30),

          /// --- Variation Section (Single Select) ---
          if (product.variations != null && product.variations.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Choose a Variation",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: context.screenHeight * .01),
                BlocBuilder<ProductDetailBloc, ProductDetailState>(
                  builder: (context, state) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 3,
                      children:
                          product.variations.map((variation) {
                            final isSelected = state.selectedVariations
                                .contains(variation);
                            return ChoiceChip(
                              label: Text(
                                "${variation.variationName.toString().capitalizeEachWord()} (Rs. ${variation.variationPrice})",
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.customThemeLightColor,
                              onSelected: (_) {
                                context.read<ProductDetailBloc>().add(
                                  SelectVariationEvent(variation),
                                );
                              },
                              labelStyle: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? AppColors.customThemeLightColor
                                        : Colors.grey.shade300,
                              ),
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            );
                          }).toList(),
                    );
                  },
                ),
              ],
            ),

          SizedBox(height: context.screenHeight * .01),

          /// --- Add-ons Section (Multi Select) ---
          if (product.addOn != null && product.addOn.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Add-ons",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: context.screenHeight * .01),
                BlocBuilder<ProductDetailBloc, ProductDetailState>(
                  builder: (context, state) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 3,
                      children:
                          product.addOn.map((addOn) {
                            final isSelected = state.selectedAddOns.contains(
                              addOn,
                            );
                            return FilterChip(
                              label: Text(
                                "${addOn.addOnName.toString().capitalizeEachWord()} (Rs. ${addOn.addOnPrice})",
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.customThemeLightColor,
                              onSelected: (_) {
                                context.read<ProductDetailBloc>().add(
                                  ToggleAddOnEvent(addOn),
                                );
                              },
                              labelStyle: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? AppColors.customThemeLightColor
                                        : Colors.grey.shade300,
                              ),
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            );
                          }).toList(),
                    );
                  },
                ),
              ],
            ),

          SizedBox(height: context.screenHeight * .01),

          /// --- Add to Cart Button ---
          BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, productState) {
              return BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Add to Cart"),
                      onPressed: () {
                        // Variation Validation

                        final selectedVariation =
                            productState.selectedVariations.isNotEmpty
                                ? productState.selectedVariations.first
                                : null;
                        if ((product.variations.isNotEmpty ?? false) &&
                            selectedVariation == null) {
                          CustomSnackbar.show(
                            context: widget.rootContext,
                            message: 'Please select a variation',
                            icon: Icons.error,
                          );
                          return;
                        }
                        final selectedAddOns = productState.selectedAddOns;

                        final cartItem = Items(
                          id: product.productId.toString(),
                          productId: product.productId.toString(),
                          productName: product.title ?? '',
                          productPrice:
                              double.tryParse(product.price ?? '0.0') ?? 0.0,
                          quantity: 1,
                          saleTax: 0.0,
                          imageUrl: '$filesBaseUrl/${product.productImage}',
                          variation: selectedVariation,
                          addOns: selectedAddOns,
                          category: product.category,
                          categoryId: product.categoryId,
                          companyId: product.companyId,
                          kitchenId: product.kitchenId,
                          kitchenName: product.kitchenName,
                          printerIp: product.printerIp,
                          productCode: product.productCode,
                        );

                        // Add to cart
                        context.read<CartBloc>().add(AddItemToCart(cartItem));
                        context.read<CartBloc>().add(LoadCart());
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.customThemeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
