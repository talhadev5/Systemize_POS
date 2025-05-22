import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:systemize_pos/bloc/navbar_bloc/navbar_event.dart';
import 'package:systemize_pos/bloc/navbar_bloc/navbar_state.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/components/app_bar.dart';
import 'package:systemize_pos/configs/routes/routes_name.dart';
import 'package:systemize_pos/view/cart/cart_screen.dart';
import 'package:systemize_pos/view/product/product.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final List<IconData> _icons = [
    Icons.dashboard,
    Icons.shopping_cart,
    Icons.person,
  ];

  final List<String> _labels = ["Products", "Cart", "Profile"];
  List<Widget>? _buildAppBarActions(int index) {
    switch (index) {
      case 0: // Products
        return [
          IconButton(
            icon: Icon(
              Icons.shopping_cart_checkout_outlined,
              color: AppColors.customThemeColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.cartScreen);
            },
          ),
        ];
      case 1: // Cart
        return [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              // Navigate to order history or similar
            },
          ),
        ];
      case 2: // Profile
        return [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ];
      default:
        return null;
    }
  }

  final List<Widget> _pages = [
    ProductsPage(),
    CartScreen(),
    Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<BottomNavBloc, BottomNavState>(
          builder: (context, state) {
            return CustomAppBar(
              text: state.title,
              actions: _buildAppBarActions(state.selectedIndex),
            );
          },
        ),
      ),
      extendBody: true,
      backgroundColor: Colors.grey.shade100,
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        buildWhen:
            (previous, current) =>
                previous.selectedIndex != current.selectedIndex,
        builder: (context, state) {
          int currentIndex = state.selectedIndex;
          return _pages[currentIndex];
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: BlocBuilder<BottomNavBloc, BottomNavState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_icons.length, (index) {
                  bool isSelected = state.selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      context.read<BottomNavBloc>().add(
                        BottomNavTabChanged(index),
                      );
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration:
                          isSelected
                              ? BoxDecoration(
                                color: AppColors.customThemeLightColor,
                                borderRadius: BorderRadius.circular(30),
                              )
                              : BoxDecoration(),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppColors.customThemeColor
                                      : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _icons[index],
                              size: 18,
                              color: isSelected ? Colors.white : Colors.black54,
                            ),
                          ),
                          if (isSelected)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                _labels[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
