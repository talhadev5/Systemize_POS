// pages/order_list_page.dart
// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_bloc.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_event.dart';
import 'package:systemize_pos/bloc/order_list_bloc/order_list.state.dart';
import 'package:systemize_pos/bloc/order_list_bloc/order_list_bolc.dart';
import 'package:systemize_pos/bloc/order_list_bloc/order_list_event.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/components/app_bar.dart';
import 'package:systemize_pos/data/models/cart_model/cart_model.dart';
import 'package:systemize_pos/data/models/order_list_model/order_list_model.dart'
    as OrderModel;
import 'package:systemize_pos/data/models/hive_model/products_model.dart'
    as ProductsModel;
import 'dart:developer' as developer;
import 'package:systemize_pos/view/cart/cart_screen.dart';

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
        variationPrice: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    return ProductsModel.Variation(
      variationId: orderVariations.id,
      // productId: null,
      variationName: orderVariations.variationName,
      variationPrice: orderVariations.variationPrice,
      createdAt: DateTime.parse(orderVariations.createdAt.toString()),
      updatedAt: DateTime.parse(orderVariations.updatedAt.toString()),
    );
  }

  ProductsModel.AddOn convertAddOn(OrderModel.AddOn orderAddOn) {
    return ProductsModel.AddOn(
      addOnId: orderAddOn.addOnId,
      productId: orderAddOn.productId,
      addOnName: orderAddOn.addOnName,
      addOnPrice: orderAddOn.addOnPrice.toString(),
      createdAt: DateTime.parse(orderAddOn.createdAt.toString()),
      updatedAt: DateTime.parse(orderAddOn.updatedAt.toString()),
    );
  }

  Items convertCartItemToItems(OrderModel.CartItem cartItem) {
    return Items(
      id: cartItem.productId.toString(),
      productId: cartItem.productId.toString(),
      productName: cartItem.title ?? 'Unknown Item',
      productPrice: double.tryParse(cartItem.price.toString() ?? '0.0') ?? 0.0,
      quantity: cartItem.qty ?? 0,
      saleTax: 0.0,
      imageUrl: '',
      variation: convertVariations(cartItem.variations),
      addOns: cartItem.addOn!.map((addOn) => convertAddOn(addOn)).toList(),
      category: cartItem.category,
      categoryId: cartItem.categoryId,
      companyId: cartItem.companyId,
      kitchenId: cartItem.kitchenId,
      kitchenName: cartItem.kitchenName,
      printerIp: cartItem.printerIp,
      productCode: cartItem.productCode,
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<OrderListBloc>().add(FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customScaffoldColor,
      appBar: CustomAppBar(
        text: 'Order List',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.customThemeColor,
          ),
        ),
      ),
      body: BlocBuilder<OrderListBloc, OrderListState>(
        builder: (context, state) {
          if (state is OrderListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderListLoaded) {
            final orders = state.orders;
            print(orders.length);
            if (orders.isEmpty) {
              return const Center(child: Text('No orders found.'));
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final data = orders[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: AppColors.customBlackColor.withOpacity(0.1),
                    ),
                  ),
                  elevation: 0,
                  color: AppColors.customWhiteColor,
                  shadowColor: AppColors.customShadowColor,
                  margin: const EdgeInsets.all(5.0),
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: AppColors.customBlackColor.withOpacity(0.1),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.info?.customerName ?? 'N/A'),
                            Text('Status: ${data.status}'),
                          ],
                        ),
                        const Spacer(),
                        Text('Rs/${data.grandTotal.toString()}'),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data.info?.phone ?? ''),
                        const Spacer(),
                        Text('Date: ${data.orderDateTime ?? 'N/A'}'),
                      ],
                    ),
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Items:'),
                            ...data.cartItems!.map(
                              (item) => ListTile(
                                title: Text(item.title ?? 'N/A'),
                                trailing: Text(
                                  'Qty: ${item.qty}, Price: ${item.price ?? '0.0'}',
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    final List<Items> orderItems =
                                        data.cartItems!
                                            .map(
                                              (cartItem) =>
                                                  convertCartItemToItems(
                                                    cartItem,
                                                  ),
                                            )
                                            .toList();
                                    for (final item in orderItems) {
                                      context.read<CartBloc>().add(
                                        AddItemToCart(item),
                                      );
                                    }
                                    // context.read<CartBloc>().add(AddItemToCart(orderItems));
                                    developer.log(
                                      'Added items to cart: ${orderItems.map((e) => e.toJson()).toList()}',
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const CartScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Edit Order',
                                    style: TextStyle(
                                      color: AppColors.customBlackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}
