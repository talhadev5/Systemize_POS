class OrderListModel {
  OrderListModel({this.success, this.ordersTotal, this.data});
  late final dynamic success;
  late final dynamic ordersTotal;
  late final List<dynamic>? data;

  OrderListModel.fromJson(dynamic json) {
    // Assuming success and ordersTotal might not exist in WebSocket response
    success = json['success'] ?? true; // Default to true if not provided
    ordersTotal = json['ordersTotal'] ?? 0; // Default to 0 if not provided
    // Map the "orders" array from the nested "orders" object to data
    data =
        List.from(json['orders'] ?? []).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['ordersTotal'] = ordersTotal;
    _data['orders'] = data!.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.info,
    required this.cartItems,
    required this.type,
    required this.createdAt,
    required this.subTotal,
    required this.status,
    required this.userId,
    required this.id,
    required this.orderId,
    required this.grandTotal,
    required this.finalTotal,
    required this.discount,
    required this.change,
    required this.split,
    required this.isUploaded,
    // required this.updatedOrderCartItems,
    this.orderHistory,
    this.orderDateTime,
  });

  final Info? info;
  final List<CartItem> cartItems;
  final String type;
  final int createdAt;
  final double subTotal;
  final String status;
  final int userId;
  final int id;
  final String? orderId;
  final double grandTotal;
  final double finalTotal;
  final double discount;
  final double? change; // Changed to nullable double?
  final int split;
  final int isUploaded;
  // final List<UpdatedOrderCartItem> updatedOrderCartItems;
  final String? orderHistory;
  final String? orderDateTime;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      info: json['info'] != null ? Info.fromJson(json['info']) : null,
      cartItems:
          List.from(
            json['cartItems'],
          ).map((e) => CartItem.fromJson(e)).toList(),
      type: json['type'] as String,
      createdAt: json['createdAt'] as int,
      subTotal: (json['subTotal'] as num).toDouble(),
      status: json['status'] as String,
      userId: json['userId'] as int,
      id: json['id'] as int,
      orderId: json['orderId']?.toString(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      finalTotal: (json['finalTotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      change:
          json['change'] != null
              ? (json['change'] as num).toDouble()
              : null, // Handle null case
      split: json['split'] as int,
      isUploaded: json['isUploaded'] as int,
      // updatedOrderCartItems: List.from(json['updatedOrderCartItems'])
      //     .map((e) => UpdatedOrderCartItem.fromJson(e))
      //     .toList(),
      orderHistory: json['orderHistory'] as String?,
      orderDateTime: json['orderDateTime'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info?.toJson(),
      'cartItems': cartItems.map((e) => e.toJson()).toList(),
      'type': type,
      'createdAt': createdAt,
      'subTotal': subTotal,
      'status': status,
      'userId': userId,
      'id': id,
      'orderId': orderId,
      'grandTotal': grandTotal,
      'finalTotal': finalTotal,
      'discount': discount,
      'change': change,
      'split': split,
      'isUploaded': isUploaded,
      // 'updatedOrderCartItems': updatedOrderCartItems.map((e) => e.toJson()).toList(),
      'orderHistory': orderHistory,
      'orderDateTime': orderDateTime,
    };
  }
}

class Info {
  Info({
    this.phone,
    this.customerName,
    this.assignRider,
    this.address,
    this.tableId,
    this.tableLocation,
    this.tableNo,
    this.tableCapacity,
    this.branchId,
    this.waiter,
    this.waiterName,
  });

  final String? phone;
  final String? customerName;
  final String? assignRider;
  final String? address;
  final String? tableId;
  final String? tableLocation;
  final String? tableNo;
  final String? tableCapacity;
  final String? branchId;
  final int? waiter;
  final String? waiterName;

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      phone: json['phone'] as String?,
      customerName: json['customerName'] as String?,
      assignRider: json['assignRider'] as String?,
      address: json['address'] as String?,
      tableId: json['table_id'] as String?,
      tableLocation: json['table_location'] as String?,
      tableNo: json['table_no'] as String?,
      tableCapacity: json['table_capacity'] as String?,
      branchId: json['branch_id'] as String?,
      waiter: json['waiter'] as int,
      waiterName: json['waiterName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'customerName': customerName,
      'assignRider': assignRider,
      'address': address,
      'table_id': tableId,
      'table_location': tableLocation,
      'table_no': tableNo,
      'table_capacity': tableCapacity,
      'branch_id': branchId,
      'waiter': waiter,
      'waiterName': waiterName,
    };
  }
}

class CartItem {
  CartItem({
    required this.qty,
    required this.price,
    required this.title,
    required this.addOn,
    this.variations,
    required this.productId,
    required this.category,
    this.productVariation,
    required this.kitchenId,
    required this.printerIp,
    required this.categoryId,
    required this.companyId,
    required this.branchId,
    required this.kitchenName,
    required this.categoryName,
    required this.productCode,
    required this.favouriteItem,
    required this.additionalItem,
  });

  final int? qty; // JSON shows 1 (int)
  final String? price; // JSON shows "1450" (String), but could be null
  final String? title; // JSON shows "double flavor", but could be null
  final List<AddOn> addOn;
  final List<Variations>? variations;
  final dynamic productId; // JSON shows 20 (int)
  final String? category; // JSON shows "Pizza", but could be null
  final ProductVariation? productVariation;
  final int? kitchenId; // JSON shows 18 (int)
  final String printerIp;
  final String? categoryId; // JSON shows "2" (String), but could be null
  final String? companyId;
  final String? branchId; // JSON shows "3" (String), but could be null
  final String? kitchenName; // JSON shows "Fast Food", but could be null
  final String? categoryName; // JSON shows null or not present
  final String? productCode; // JSON shows "12345", but could be null
  final String? favouriteItem; // JSON shows "0" (String), but could be null
  final int? additionalItem; // JSON shows 0 (int)

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      qty: json['qty'] as int?,
      price: json['price'] as String?,
      title: json['title'] as String?,
      addOn: List.from(json['add_on'] ?? []).map((e) => AddOn.fromJson(e)).toList(),
      // variations: json['variations'] is Map && json['variations'] != null
      //     ? Variations.fromJson(json['variations'])
      //     : null,
      variations: json['variations'] != null
    ? List<Variations>.from(
        json['variations'].map((v) => Variations.fromJson(v)),
      )
    : null,

      productId: json['product_id'],

      category: json['category'] as String?,
      productVariation: json['product_variation'] is Map && json['product_variation'] != null
          ? ProductVariation.fromJson(json['product_variation'])
          : null,
      kitchenId: json['kitchen_id'] as int?,
      printerIp: json['printer_ip'] as String,
      categoryId: json['category_id'] as String?,
      companyId: json['company_id'] as String?,
      branchId: json['branch_id'] as String?,
      kitchenName: json['kitchen_name'] as String?,
      categoryName: json['category_name'] as String?,
      productCode: json['product_code'] as String?,
      favouriteItem: json['favourite_item'] as String?,
      additionalItem: json['additional_item'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qty': qty,
      'price': price,
      'title': title,
      'add_on': addOn.map((e) => e.toJson()).toList(),
      // 'variations': variations?.toJson(),
      'variations': variations?.map((v) => v.toJson()).toList(),

      'product_id': productId,
      'category': category,
      'product_variation': productVariation?.toJson(),
      'kitchen_id': kitchenId,

      'printer_ip': printerIp,
      'category_id': categoryId,
      'company_id': companyId,
      'branch_id': branchId,
      'kitchen_name': kitchenName,
      'category_name': categoryName,
      'product_code': productCode,
      'favourite_item': favouriteItem,
      'additional_item': additionalItem,
    };
  }
}

class AddOn {
  AddOn({
    required this.addOnId,
    required this.productId,
    required this.addOnName,
    required this.addOnPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? addOnId; // JSON shows 144 (int)
  final String? productId; // JSON shows "487" (String)
  final String? addOnName;
  final String? addOnPrice; // JSON shows "50" (String)
  final String? createdAt;
  final String? updatedAt;

  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(
      addOnId: json['addOn_id'] as int?,
      productId: json['product_id'] as String?,
      addOnName: json['addOn_name'] as String?,
      addOnPrice: json['addOn_price'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addOn_id': addOnId,
      'product_id': productId,
      'addOn_name': addOnName,
      'addOn_price': addOnPrice,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Variations {
  Variations({
    required this.variationName,
    required this.variationPrice,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  final String variationName;
  final String variationPrice; // JSON shows "450" (String)
  final int id; // JSON shows 1239 (int)
  final String createdAt;
  final String updatedAt;

  factory Variations.fromJson(Map<String, dynamic> json) {
    return Variations(
      variationName: json['variation_name'] as String,
      variationPrice: json['variation_price'] as String,
      id: json['variation_id'] as int,
      // json['variation_id'] != null
      //     ? json['variation_id'] as int
      //     : json['id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variation_name': variationName,
      'variation_price': variationPrice,
      'variation_id': id, // Match JSON key in response
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ProductVariation {
  ProductVariation({
    required this.variationName,
    required this.variationPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  final String variationName;
  final String variationPrice; // JSON shows "790" (String)
  final String createdAt;
  final String updatedAt;
  final int id; // JSON shows 307 (int)

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      variationName: json['variation_name'] as String,
      variationPrice: json['variation_price'].toString(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      id: json['variation_id'] as int,
      // json['variation_id'] != null
      //     ? json['variation_id'] as int
      //     : json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'variation_name': variationName,
      'variation_price': variationPrice,
      'variation_id': id, // Match JSON key in response
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
