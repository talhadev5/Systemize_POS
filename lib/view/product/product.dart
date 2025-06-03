import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_bloc.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_event.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_state.dart';
import 'package:systemize_pos/bloc/product_bloc/product_bloc.dart';
import 'package:systemize_pos/bloc/product_bloc/product_event.dart';
import 'package:systemize_pos/bloc/product_bloc/product_state.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:systemize_pos/configs/widgets/custom_loader.dart';
import 'package:systemize_pos/utils/app_url.dart';
import 'package:systemize_pos/utils/extensions/string_extension.dart';
import 'package:systemize_pos/utils/extensions/media_query_extensions.dart';
import 'package:systemize_pos/view/product/product_details.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductApi()); // <-- Dispatch API fetch
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // appBar: CustomAppBar(text: 'Products'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //  serach Bar.........
            SizedBox(
              height: 50, // <-- Set your desired height here

              child: CupertinoSearchTextField(
                onChanged: (query) {
                  context.read<ProductBloc>().add(UpdateSearchQuery(query));
                },
                style: TextStyle(fontSize: 16),
                placeholder: 'Search...',
                placeholderStyle: TextStyle(color: Colors.grey),
                itemColor: Colors.grey.shade600,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                backgroundColor: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: context.screenHeight * .02),

            //  category toggle.........
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return Row(
                    children:
                        state.categories.map((category) {
                          final isSelected = state.selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (_) {
                                context.read<ProductBloc>().add(
                                  SelectCategory(category),
                                );
                              },
                              selectedColor: AppColors.customThemeColor,
                              backgroundColor: Colors.grey.shade200,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              checkmarkColor: Colors.white,
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? AppColors.customThemeColor
                                        : Colors.transparent,
                                width: 1.5,
                              ),
                              pressElevation: 0,
                              elevation: 0,
                              shadowColor: AppColors.customThemeColor,
                              visualDensity: VisualDensity.compact,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ),

            SizedBox(height: context.screenHeight * .02),
            //  Product List............
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, cartstate) {
                  return BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state.productStatus == ProductStatus.loading) {
                        return const DefultLoader();
                      } else if (state.productStatus == ProductStatus.error) {
                        context.read<ProductBloc>().add(
                          ProductApi(forceRefresh: true),
                        );
                        //  Center(
                        //   child: Text(
                        //     state.message,
                        //     style: TextStyle(color: Colors.red),
                        //   ),
                        // );
                      }
                      if (state.filteredProducts.isEmpty) {
                        return const Center(child: Text("No products found"));
                      }

                      return RefreshIndicator(
                        color: AppColors.customThemeColor,
                        onRefresh: () async {
                          context.read<ProductBloc>().add(
                            ProductApi(forceRefresh: true),
                          );
                        },
                        child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            top: 0,
                            left: 12,
                            right: 12,
                            bottom: context.bottomPadding * .9,
                          ),
                          itemCount: state.filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 3 / 4.2,
                              ),
                          itemBuilder: (context, index) {
                            final product = state.filteredProducts[index];
                            final isTapped = state.tappedIndex == index;
                            final isInCart = cartstate.cartItems.any(
                              (item) =>
                                  item.productId ==
                                  product.productId.toString(),
                            );

                            return AnimatedScale(
                              scale:
                                  isTapped
                                      ? 0.95
                                      : 1.0, // scale down when tapped
                              duration: const Duration(milliseconds: 100),
                              child: GestureDetector(
                                onTap: () {
                                  context.read<ProductBloc>().add(
                                    TapProduct(index: index),
                                  );

                                  // After a short delay, reset tapped index to remove animation
                                  Future.delayed(
                                    const Duration(milliseconds: 200),
                                    () {
                                      showModalBottomSheet(
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24),
                                          ),
                                        ),
                                        builder: (context) {
                                          return ProductDetailSheet(
                                            product: product,
                                            rootContext: context,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },

                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.08,
                                        ),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Image
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                        child: Container(
                                          height:
                                              120, // set your desired height
                                          width:
                                              double
                                                  .infinity, // full width of parent container
                                          color: Colors.grey.shade100,
                                          alignment: Alignment.center,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                product.productImage != null &&
                                                        product
                                                            .productImage!
                                                            .isNotEmpty
                                                    ? "$filesBaseUrl${product.productImage}"
                                                    : '',
                                            // fit:
                                            //     BoxFit
                                            //         .contain, // or BoxFit.cover depending on your need
                                            placeholder:
                                                (context, url) => const Icon(
                                                  Icons.image_outlined,
                                                  size: 48,
                                                  color: Colors.grey,
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => const Icon(
                                                  Icons.broken_image_outlined,
                                                  size: 48,
                                                  color: Colors.grey,
                                                ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.title
                                                  .toString()
                                                  .capitalizeEachWord(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              product.category
                                                  .toString()
                                                  .capitalizeEachWord(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors
                                                            .grey
                                                            .shade200, // light background
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade200,
                                                      width: 1.2,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Rs. ${product.price}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors
                                                              .customBlackColor,
                                                    ),
                                                  ),
                                                ),
                                                if (isInCart)
                                                  const Icon(
                                                    Icons.check_circle,
                                                    color:
                                                        AppColors
                                                            .customThemeColor,
                                                    size: 20,
                                                  )
                                                else
                                                  const Icon(
                                                    Icons.add_shopping_cart,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
