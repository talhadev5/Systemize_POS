import 'package:systemize_pos/data/models/hive_model/products_model.dart';

class Items {
  final String id;
  final String productId;
  final String productName;
  final double productPrice;
  int quantity;
  double saleTax;
  final String imageUrl;
  final Variation? variation;
  List<AddOn> addOns;
  String? category;
  String? categoryId; // Added
  String? companyId; // Added
  num? kitchenId; // Added
  String? kitchenName; // Added
  String? printerIp; // Added
  String? productCode; // Added

  Items({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.saleTax,
    required this.imageUrl,
    this.variation,
    this.addOns = const [],
    this.category,
    this.categoryId,
    this.companyId,
    this.kitchenId,
    this.kitchenName,
    this.printerIp,
    this.productCode,
  });

  double get variationPrice =>
      variation != null
          ? double.parse(variation!.variationPrice.toString())
          : 0.0;
  double get addOnsTotalPrice => addOns.fold(
    0.0,
    (sum, addOn) => sum + double.parse(addOn.addOnPrice!) * quantity,
  );
  // double get subtotal => (variationPrice) * quantity + addOnsTotalPrice;
  double get effectiveProductPrice =>
      variation != null
          ? double.parse(variation!.variationPrice.toString())
          : productPrice;
  double get subtotal => effectiveProductPrice * quantity + addOnsTotalPrice;
  double get total => subtotal + saleTax;

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      productPrice: json['productPrice'],
      quantity: json['quantity'],
      saleTax: json['saleTax'],
      imageUrl: json['imageUrl'],
      variation:
          json['variation'] != null
              ? Variation.fromJson(json['variation'])
              : null,
      addOns:
          (json['addOns'] as List<dynamic>)
              .map((addOnJson) => AddOn.fromJson(addOnJson))
              .toList(),
      category: json['category'],
      categoryId: json['category_id'],
      companyId: json['company_id'],
      kitchenId: json['kitchen_id'],
      kitchenName: json['kitchen_name'],
      printerIp: json['printer_ip'],
      productCode: json['product_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'saleTax': saleTax,
      'imageUrl': imageUrl,
      'variation': variation?.toJson(),
      'addOns': addOns.map((addOn) => addOn.toJson()).toList(),
      'category': category,
      'category_id': categoryId,
      'company_id': companyId,
      'kitchen_id': kitchenId,
      'kitchen_name': kitchenName,
      'printer_ip': printerIp,
      'product_code': productCode,
    };
  }

  Items copyWith({
    String? id,
    String? productId,
    String? productName,
    double? productPrice,
    int? quantity,
    double? saleTax,
    String? imageUrl,
    Variation? variation,
    List<AddOn>? addOns,
    String? category,
    String? categoryId,
    String? companyId,
    num? kitchenId,
    String? kitchenName,
    String? printerIp,
    String? productCode,
  }) {
    return Items(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      saleTax: saleTax ?? this.saleTax,
      imageUrl: imageUrl ?? this.imageUrl,
      variation: variation ?? this.variation,
      addOns: addOns ?? List<AddOn>.from(this.addOns),
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      companyId: companyId ?? this.companyId,
      kitchenId: kitchenId ?? this.kitchenId,
      kitchenName: kitchenName ?? this.kitchenName,
      printerIp: printerIp ?? this.printerIp,
      productCode: productCode ?? this.productCode,
    );
  }
}
