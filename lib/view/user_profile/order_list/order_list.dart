// pages/order_list_page.dart
// ignore_for_file: library_prefixes

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_bloc.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_event.dart';
import 'package:systemize_pos/bloc/order_list_bloc/order_list.state.dart';
import 'package:systemize_pos/bloc/order_list_bloc/order_list_bolc.dart';
import 'package:systemize_pos/bloc/order_list_bloc/order_list_event.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/components/app_bar.dart';
import 'package:systemize_pos/configs/routes/routes_name.dart';
import 'package:systemize_pos/configs/widgets/custom_loader.dart';
import 'package:systemize_pos/data/models/cart_model/cart_model.dart';
import 'package:systemize_pos/data/models/order_list_model/order_list_model.dart'
    as OrderModel;
import 'package:systemize_pos/data/models/hive_model/products_model.dart'
    as ProductsModel;
import 'package:systemize_pos/utils/extensions/media_query_extensions.dart';
import 'package:systemize_pos/utils/extensions/string_extension.dart';
import 'dart:developer' as developer;

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final ScrollController _scrollController = ScrollController();

  ProductsModel.Variation convertVariations(
    OrderModel.Variations? orderVariations,
  ) {
    if (orderVariations == null) {
      return ProductsModel.Variation(
        variationName: 'No Variation',
        variationPrice: '0.0',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    // if (orderVariations == null) return null;
    return ProductsModel.Variation(
      variationId: orderVariations.id,
      variationName: orderVariations.variationName ?? 'No Name',
      variationPrice: orderVariations.variationPrice ?? '0.0',
      createdAt: _parseDateTime(orderVariations.createdAt),
      updatedAt: _parseDateTime(orderVariations.updatedAt),
    );
  }

  ProductsModel.AddOn convertAddOn(OrderModel.AddOn orderAddOn) {
    return ProductsModel.AddOn(
      addOnId: orderAddOn.addOnId,
      productId: orderAddOn.productId,
      addOnName: orderAddOn.addOnName ?? 'Unknown AddOn',
      addOnPrice: orderAddOn.addOnPrice?.toString() ?? '0.0',
      createdAt: _parseDateTime(orderAddOn.createdAt),
      updatedAt: _parseDateTime(orderAddOn.updatedAt),
    );
  }

  Items convertCartItemToItems(OrderModel.CartItem cartItem) {
    final variation =
        (cartItem.variations != null && cartItem.variations!.isNotEmpty)
            ? convertVariations(cartItem.variations!.first)
            : null;
    return Items(
      id: cartItem.productId.toString(),
      productId: cartItem.productId.toString(),
      productName: cartItem.title ?? 'Unknown Item',
      productPrice: double.tryParse(cartItem.price ?? '0.0') ?? 0.0,
      quantity: int.parse(cartItem.qty.toString()),
      saleTax: 0.0,
      imageUrl: '',
      // variation: cartItem.variations?.map(convertVariations).toList(),
      //
      variation: variation,
      addOns: cartItem.addOn.map(convertAddOn).toList() ?? [],
      category: cartItem.category ?? '',
      categoryId: cartItem.categoryId,
      companyId: cartItem.companyId,
      kitchenId: cartItem.kitchenId,
      kitchenName: cartItem.kitchenName,
      printerIp: cartItem.printerIp,
      productCode: cartItem.productCode,
    );
  }

  DateTime _parseDateTime(dynamic date) {
    if (date == null) return DateTime.now();
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<OrderListBloc>().add(FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor:
            AppColors.customThemeColor, // Set your desired color here
        statusBarIconBrightness: Brightness.light, // For white icons
        statusBarBrightness: Brightness.dark, // iOS only
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.customScaffoldColor,
          appBar: CustomAppBar(
            text: 'Order List',
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.customThemeColor,
              ),
            ),
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                    bottom: 0,
                  ),
                  child: SizedBox(
                    height: 50, // <-- Set your desired height here

                    child: CupertinoSearchTextField(
                      onChanged: (query) {
                        context.read<OrderListBloc>().add(
                          UpdateSearchQuery(query),
                        );
                      },
                      style: TextStyle(fontSize: 16),
                      placeholder: 'Search by customer name...',
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
                ),
                BlocBuilder<OrderListBloc, OrderListState>(
                  builder: (context, state) {
                    if (state is OrderListLoading) {
                      return SizedBox(
                        height: context.screenHeight * 0.8,
                        child: const DefultLoader(),
                      );
                    } else if (state is OrderListLoaded) {
                      final orders = state.orders;
                      if (orders.isEmpty) {
                        return SizedBox(
                          height: context.screenHeight * 0.8,
                          child: const Center(child: Text('No orders found.')),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final data = orders[index];

                          return Card(
                            color: AppColors.customWhiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            child: ExpansionTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.info?.customerName
                                            ?.capitalizeEachWord() ??
                                        'N/A',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Total: Rs ${data.grandTotal.toString()}",
                                    style: const TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              subtitle: Text(
                                "Date: ${data.orderDateTime ?? 'N/A'}",
                              ),
                              children: [
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Items:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            ' ${data.type.capitalize()}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      ...data.cartItems.map((item) {
                                        // final variation =
                                        //     (item.variations != null &&
                                        //             item.variations!.isNotEmpty)
                                        //         ? item.variations!.first
                                        //         : null;
                                        final variations =
                                            item.variations ?? [];
                                        final addons = item.addOn ?? [];

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '• ${item.title.toString().capitalizeEachWord()}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              if (variations.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 12,
                                                        top: 2,
                                                      ),
                                                  child: Column(
                                                    children:
                                                        variations.map((
                                                          variation,
                                                        ) {
                                                          return Text(
                                                            'Variation: ${variation.variationName ?? 'Unknown'} - Rs ${variation.variationPrice ?? '0.0'}',
                                                            style: const TextStyle(
                                                              color:
                                                                  Colors
                                                                      .black87,
                                                            ),
                                                          );
                                                        }).toList(),
                                                  ),
                                                ),
                                              if (addons.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 12,
                                                        top: 2,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children:
                                                        addons.map((addon) {
                                                          return Text(
                                                            'Add-on: ${addon.addOnName} - Rs ${addon.addOnPrice}',
                                                            style: const TextStyle(
                                                              color:
                                                                  Colors
                                                                      .black87,
                                                            ),
                                                          );
                                                        }).toList(),
                                                  ),
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 12,
                                                  top: 4,
                                                ),
                                                child: Text(
                                                  'Qty: ${item.qty}',
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                              const Divider(height: 20),
                                            ],
                                          ),
                                        );
                                      }).toList(),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            final List<Items> orderItems =
                                                data.cartItems
                                                    .map(
                                                      (cartItem) =>
                                                          convertCartItemToItems(
                                                            cartItem,
                                                          ),
                                                    )
                                                    .toList();

                                            final orderId = data.id;

                                            developer.log(
                                              ' Parsed orderId: $orderId',
                                            );
                                            context.read<CartBloc>().add(
                                              LoadOrderId(orderId),
                                            );

                                            // context.read<CartBloc>().add(ClearCart());
                                            context.read<CartBloc>().add(
                                              AddItemToCart(orderItems),
                                            );

                                            Navigator.popAndPushNamed(
                                              context,
                                              RoutesName.cartScreen,
                                            );
                                          },

                                          icon: const Icon(
                                            Icons.edit,
                                            size: 18,
                                          ),
                                          label: const Text('Edit Order'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.customThemeColor,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (state is OrderListError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else {
                      return const Center(child: Text('Unknown state'));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
