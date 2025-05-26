import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_bloc.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_event.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_state.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/components/app_bar.dart';
import 'package:systemize_pos/configs/components/custom_cart_list.dart';
import 'package:systemize_pos/configs/widgets/custom_button.dart';
import 'package:systemize_pos/configs/widgets/custom_textfield.dart';
import 'package:systemize_pos/data/models/hive_model/products_model.dart';
import 'package:systemize_pos/utils/extensions/string_extension.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
  }

  String _buildAddOnsList(List<AddOn> addOns) {
    return addOns.map((addOn) => '${addOn.addOnName}').join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),

        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return CustomAppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: AppColors.customThemeColor),
              ),
              text: 'Cart',
              actions: [
                if (state.cartItems.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.customThemeColor,
                    ),
                    onPressed: () => context.read<CartBloc>().add(ClearCart()),
                  ),
                if (state.heldItems.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.pause_circle,
                      color: AppColors.customThemeColor,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (context) => _buildHeldCartBottomSheet(context),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),

      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              // --- Cart Items List ---
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = state.cartItems[index];
                    return CustomCartListview(
                      image: item.imageUrl,
                      productName: item.productName,
                      addonProduct:
                          item.addOns.isNotEmpty
                              ? _buildAddOnsList(item.addOns)
                              : '',
                      addonPrice: item.addOnsTotalPrice.toString(),
                      variationPrice:
                          item.variation != null
                              ? item.variationPrice.toString()
                              : '',
                      productVariation: item.variation?.variationName ?? '',
                      productPrice: item.productPrice.toString(),
                      quantity: item.quantity,
                      onIncrease: () {
                        context.read<CartBloc>().add(
                          UpdateItemQuantity(item, item.quantity + 1),
                        );
                      },
                      onDecrease: () {
                        if (item.quantity > 1) {
                          context.read<CartBloc>().add(
                            UpdateItemQuantity(item, item.quantity - 1),
                          );
                        } else {
                          context.read<CartBloc>().add(
                            RemoveItemFromCart(item),
                          );
                        }
                      },
                      onDelete: () {
                        context.read<CartBloc>().add(RemoveItemFromCart(item));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty || state.heldItems.isNotEmpty) {
            return const SizedBox();
          }

          return Container(
            height: 170,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side: Summary
                Expanded(
                  // flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow('Subtotal', state.subTotal),
                      _buildSummaryRow('Sales Tax', state.totalSaleTax),
                      _buildSummaryRow('Items', state.totalItems.toDouble()),
                      const Divider(thickness: 1.2),
                      _buildSummaryRow(
                        'Grand Total',
                        state.grandTotal,
                        isBold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Right Side: Buttons
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder:
                                  (_) => _showOrderDetailsBottomSheet(context),
                            );
                            // context.read<CartBloc>().add(SubmitCartOrder());
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text("Save & Kitchen"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.customThemeColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<CartBloc>().add(HoldCart());
                          },
                          icon: const Icon(Icons.pause_circle_outline),
                          label: const Text("Hold Cart"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.deepOrange,
                            side: const BorderSide(color: Colors.deepOrange),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Rs ',
                  style: TextStyle(
                    fontSize: 10, // smaller size for "Rs"
                    color: Colors.black87,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 14, // normal size for amount
                    color: Colors.black87,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeldCartBottomSheet(BuildContext context) {
    final state = context.read<CartBloc>().state;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder:
            (_, controller) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Held Orders',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          context.read<CartBloc>().add(ClearHeldCart());
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Clear All'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: state.heldItems.length,
                      itemBuilder: (context, index) {
                        final held = state.heldItems[index];
                        return Card(
                          color: AppColors.customWhiteColor,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              held.productName.toString().capitalizeEachWord(),
                              style: TextStyle(
                                color: AppColors.customBlackColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Qty: ${held.quantity}'),
                                Text(
                                  'Price: Rs ${held.subtotal.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  MoveHeldItemToCart(held),
                                );
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.customThemeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Move to Cart',
                                style: TextStyle(
                                  color: AppColors.customWhiteColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  // order details.............
  Widget _showOrderDetailsBottomSheet(BuildContext context) {
    String selectedOrderType = 'dineIn';
    final customerNameController = TextEditingController();
    final orderNoteController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Order Details",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),

                  /// Customer Name
                  CustomTextField(
                    key: const ValueKey("customerName"),
                    labelText: "Customer Name",
                    hintText: "e.g. John Doe (optional)",
                    prefixIcon: Icons.person,
                    controller: customerNameController,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return "Customer name is required";
                    //   }
                    //   return null;
                    // },
                    onChanged: (value) {},
                    onEditingComplete: () {},
                  ),
                  const SizedBox(height: 16),

                  /// Order Note
                  CustomTextField(
                    key: const ValueKey("orderNote"),
                    labelText: "Order Note",
                    hintText: "e.g. kitchen, allergy info (optional)",
                    prefixIcon: Icons.note,
                    controller: orderNoteController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    onChanged: (value) {},
                    onEditingComplete: () {},
                  ),
                  const SizedBox(height: 20),

                  /// Order Type Selection
                  const Text(
                    "Order Type",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween, // or spaceEvenly/spaceAround as you want
                    children:
                        ['dineIn', 'takeAway'].map((type) {
                          return Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                setModalState(() {
                                  selectedOrderType = type;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 8),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        selectedOrderType == type
                                            ? AppColors.customThemeColor
                                            : Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: type,
                                      groupValue: selectedOrderType,
                                      activeColor: AppColors.customThemeColor,
                                      onChanged: (value) {
                                        setModalState(() {
                                          selectedOrderType = value!;
                                        });
                                      },
                                    ),
                                    SizedBox(width: 4),
                                    Text(type.toString().capitalizeEachWord()),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 24),

                  /// Save Button
                  CustomButton(
                    title: 'Save & Kitchen',
                    borderRadius: 20,
                    height: 50,
                    onTap: () {
                      print("name.......${customerNameController.text.trim()}");
                      print(
                        "orderNote.......${orderNoteController.text.trim()}",
                      );
                      print("type......${selectedOrderType}");
                      context.read<CartBloc>().add(
                        SubmitCartOrderWithDetails(
                          customerName: customerNameController.text.trim(),
                          orderNote: orderNoteController.text.trim(),
                          orderType: selectedOrderType,
                        ),
                      );
                      context.read<CartBloc>().add(SubmitCartOrder());
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
