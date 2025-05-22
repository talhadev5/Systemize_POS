import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemize_pos/data/models/cart_model/cart_model.dart';

class CartService {
  static const _cartKey = 'cartItems';

  static Future<List<Items>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList(_cartKey) ?? [];
    return cartData.map((json) => Items.fromJson(jsonDecode(json))).toList();
  }

  static Future<void> saveCart(List<Items> items) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, cartJson);
  }
}
