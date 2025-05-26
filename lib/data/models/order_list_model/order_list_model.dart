// class OrderListModel {
//   OrderListModel({
//     // required this.success,
//     // required this.ordersTotal,
//     required this.data,
//   });
//   // late final dynamic success;
//   // late final dynamic ordersTotal;
//   late final List<dynamic> data;

//   OrderListModel.fromJson(dynamic json) {
//     // Assuming success and ordersTotal might not exist in WebSocket response
//     // success = json['success'] ?? true; // Default to true if not provided
//     // ordersTotal = json['ordersTotal'] ?? 0; // Default to 0 if not provided
//     // Map the "orders" array from the nested "orders" object to data
//     // data = List.from(json['orders'] ?? []).map((e) => Data.fromJson(e)).toList();
//    data = List.from(json['orders'] ?? []).map((e) => Data.fromJson(e)).toList();

//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     // _data['success'] = success;
//     // _data['ordersTotal'] = ordersTotal;
//     _data['data'] = data.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

// class Data {
//   Data({
//     required this.info,
//     required this.cartItems,
//     required this.type,
//     required this.createdAt,
//     required this.subTotal,
//     required this.status,
//     required this.userId,
//     required this.id,
//     required this.orderId,
//     required this.grandTotal,
//     required this.finalTotal,
//     required this.discount,
//     required this.change,
//     required this.split,
//     required this.isUploaded,
//     // required this.updatedOrderCartItems,
//     this.orderHistory,
//     this.orderDateTime,
//   });

//   final Info? info;
//   final List<CartItem> cartItems;
//   final String type;
//   final int createdAt;
//   final double subTotal;
//   final String status;
//   final int userId;
//   final String id;
//   final String? orderId;
//   final double grandTotal;
//   final double finalTotal;
//   final double discount;
//   final double? change; // Changed to nullable double?
//   final int split;
//   final int isUploaded;
//   // final List<UpdatedOrderCartItem> updatedOrderCartItems;
//   final String? orderHistory;
//   final String? orderDateTime;

//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       info: json['info'] != null ? Info.fromJson(json['info']) : null,
//       cartItems:
//           List.from(
//             json['cartItems'],
//           ).map((e) => CartItem.fromJson(e)).toList(),
//       type: json['type'] as String,
//       createdAt: json['createdAt'] as int,
//       subTotal: (json['subTotal'] as num).toDouble(),
//       status: json['status'] as String,
//       userId: json['userId'] as int,
//       id: json['id'].toString(),
//       orderId: json['orderId']?.toString(),
//       grandTotal: (json['grandTotal'] as num).toDouble(),
//       finalTotal: (json['finalTotal'] as num).toDouble(),
//       discount: (json['discount'] as num).toDouble(),
//       change:
//           json['change'] != null
//               ? (json['change'] as num).toDouble()
//               : null, // Handle null case
//       split: json['split'] as int,
//       isUploaded: json['isUploaded'] as int,
//       // updatedOrderCartItems: List.from(json['updatedOrderCartItems'])
//       //     .map((e) => UpdatedOrderCartItem.fromJson(e))
//       //     .toList(),
//       orderHistory: json['orderHistory'] as String?,
//       orderDateTime: json['orderDateTime'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'info': info?.toJson(),
//       'cartItems': cartItems.map((e) => e.toJson()).toList(),
//       'type': type,
//       'createdAt': createdAt,
//       'subTotal': subTotal,
//       'status': status,
//       'userId': userId,
//       'id': id,
//       'orderId': orderId,
//       'grandTotal': grandTotal,
//       'finalTotal': finalTotal,
//       'discount': discount,
//       'change': change,
//       'split': split,
//       'isUploaded': isUploaded,
//       // 'updatedOrderCartItems': updatedOrderCartItems.map((e) => e.toJson()).toList(),
//       'orderHistory': orderHistory,
//       'orderDateTime': orderDateTime,
//     };
//   }
// }

// class Info {
//   Info({
//     this.phone,
//     this.customerName,
//     this.assignRider,
//     this.address,
//     this.tableId,
//     this.tableLocation,
//     this.tableNo,
//     this.tableCapacity,
//     this.branchId,
//     this.waiter,
//     this.waiterName,
//   });

//   final String? phone;
//   final String? customerName;
//   final String? assignRider;
//   final String? address;
//   final String? tableId;
//   final String? tableLocation;
//   final String? tableNo;
//   final String? tableCapacity;
//   final String? branchId;
//   final String? waiter;
//   final String? waiterName;

//   factory Info.fromJson(Map<String, dynamic> json) {
//     return Info(
//       phone: json['phone'] as String?,
//       customerName: json['customerName'] as String?,
//       assignRider: json['assignRider'] as String?,
//       address: json['address'] as String?,
//       tableId: json['table_id'] as String?,
//       tableLocation: json['table_location'] as String?,
//       tableNo: json['table_no'] as String?,
//       tableCapacity: json['table_capacity'] as String?,
//       branchId: json['branch_id'] as String?,
//       waiter: json['waiter'] as String?,
//       waiterName: json['waiterName'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'phone': phone,
//       'customerName': customerName,
//       'assignRider': assignRider,
//       'address': address,
//       'table_id': tableId,
//       'table_location': tableLocation,
//       'table_no': tableNo,
//       'table_capacity': tableCapacity,
//       'branch_id': branchId,
//       'waiter': waiter,
//       'waiterName': waiterName,
//     };
//   }
// }

// class CartItem {
//   CartItem({
//     required this.qty,
//     required this.price,
//     required this.title,
//     required this.addOn,
//     this.variations,
//     required this.productId,
//     required this.category,
//     this.productVariation,
//     required this.kitchenId,
//     required this.printerIp,
//     required this.categoryId,
//     required this.companyId,
//     required this.branchId,
//     required this.kitchenName,
//     required this.categoryName,
//     required this.productCode,
//     required this.favouriteItem,
//     required this.additionalItem,
//   });

//   final int? qty; // JSON shows 1 (int)
//   final String? price; // JSON shows "1450" (String), but could be null
//   final String? title; // JSON shows "double flavor", but could be null
//   final List<AddOn> addOn;
//   final Variations? variations;
//   final dynamic productId; // JSON shows 20 (int)
//   final String? category; // JSON shows "Pizza", but could be null
//   final ProductVariation? productVariation;
//   final int? kitchenId; // JSON shows 18 (int)
//   final String printerIp;
//   final String? categoryId; // JSON shows "2" (String), but could be null
//   final String? companyId;
//   final String? branchId; // JSON shows "3" (String), but could be null
//   final String? kitchenName; // JSON shows "Fast Food", but could be null
//   final String? categoryName; // JSON shows null or not present
//   final String? productCode; // JSON shows "12345", but could be null
//   final String? favouriteItem; // JSON shows "0" (String), but could be null
//   final int? additionalItem; // JSON shows 0 (int)

//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     return CartItem(
//       qty: json['qty'] as int?,
//       price: json['price'] as String?,
//       title: json['title'] as String?,
//       addOn:
//           List.from(
//             json['add_on'] ?? [],
//           ).map((e) => AddOn.fromJson(e)).toList(),
//       variations:
//           json['variations'] is Map && json['variations'] != null
//               ? Variations.fromJson(json['variations'])
//               : null,
//       productId: json['product_id'],

//       category: json['category'] as String?,
//       productVariation:
//           json['product_variation'] is Map && json['product_variation'] != null
//               ? ProductVariation.fromJson(json['product_variation'])
//               : null,
//       kitchenId: json['kitchen_id'] as int?,
//       printerIp: json['printer_ip'] as String,
//       categoryId: json['category_id'] as String?,
//       companyId: json['company_id'] as String?,
//       branchId: json['branch_id'] as String?,
//       kitchenName: json['kitchen_name'] as String?,
//       categoryName: json['category_name'] as String?,
//       productCode: json['product_code'] as String?,
//       favouriteItem: json['favourite_item'] as String?,
//       additionalItem: json['additional_item'] as int?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'qty': qty,
//       'price': price,
//       'title': title,
//       'add_on': addOn.map((e) => e.toJson()).toList(),
//       'variations': variations?.toJson(),
//       'product_id': productId,
//       'category': category,
//       'product_variation': productVariation?.toJson(),
//       'kitchen_id': kitchenId,

//       'printer_ip': printerIp,
//       'category_id': categoryId,
//       'company_id': companyId,
//       'branch_id': branchId,
//       'kitchen_name': kitchenName,
//       'category_name': categoryName,
//       'product_code': productCode,
//       'favourite_item': favouriteItem,
//       'additional_item': additionalItem,
//     };
//   }
// }

// class AddOn {
//   AddOn({
//     required this.addOnId,
//     required this.productId,
//     required this.addOnName,
//     required this.addOnPrice,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   final int? addOnId; // JSON shows 144 (int)
//   final String? productId; // JSON shows "487" (String)
//   final String? addOnName;
//   final String? addOnPrice; // JSON shows "50" (String)
//   final String? createdAt;
//   final String? updatedAt;

//   factory AddOn.fromJson(Map<String, dynamic> json) {
//     return AddOn(
//       addOnId: json['addOn_id'] as int?,
//       productId: json['product_id'] as String?,
//       addOnName: json['addOn_name'] as String?,
//       addOnPrice: json['addOn_price'] as String?,
//       createdAt: json['created_at'] as String?,
//       updatedAt: json['updated_at'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'addOn_id': addOnId,
//       'product_id': productId,
//       'addOn_name': addOnName,
//       'addOn_price': addOnPrice,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//     };
//   }
// }

// class Variations {
//   Variations({
//     required this.variationName,
//     required this.variationPrice,
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   final String variationName;
//   final String variationPrice; // JSON shows "450" (String)
//   final int id; // JSON shows 1239 (int)
//   final String createdAt;
//   final String updatedAt;

//   factory Variations.fromJson(Map<String, dynamic> json) {
//     return Variations(
//       variationName: json['variation_name'] as String,
//       variationPrice: json['variation_price'] as String,
//       id:
//           json['variation_id'] != null
//               ? json['variation_id'] as int
//               : json['id'] as int,
//       createdAt: json['created_at'] as String,
//       updatedAt: json['updated_at'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'variation_name': variationName,
//       'variation_price': variationPrice,
//       'variation_id': id, // Match JSON key in response
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//     };
//   }
// }

// class ProductVariation {
//   ProductVariation({
//     required this.variationName,
//     required this.variationPrice,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.id,
//   });

//   final String variationName;
//   final String variationPrice; // JSON shows "790" (String)
//   final String createdAt;
//   final String updatedAt;
//   final int id; // JSON shows 307 (int)

//   factory ProductVariation.fromJson(Map<String, dynamic> json) {
//     return ProductVariation(
//       variationName: json['variation_name'] as String,
//       variationPrice: json['variation_price'] as String,
//       createdAt: json['created_at'] as String,
//       updatedAt: json['updated_at'] as String,
//       id:
//           json['variation_id'] != null
//               ? json['variation_id'] as int
//               : json['id'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'variation_name': variationName,
//       'variation_price': variationPrice,
//       'variation_id': id, // Match JSON key in response
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//     };
//   }
// }

// class OrderListModel {
//   OrderListModel({
//     // required this.success,
//     // required this.ordersTotal,
//     required this.data,
//   });
//   // late final dynamic success;
//   // late final dynamic ordersTotal;
//   late final List<dynamic> data;

//   OrderListModel.fromJson(dynamic json) {
//     // Assuming success and ordersTotal might not exist in WebSocket response
//     // success = json['success'] ?? true; // Default to true if not provided
//     // ordersTotal = json['ordersTotal'] ?? 0; // Default to 0 if not provided
//     // Map the "orders" array from the nested "orders" object to data
//     // data = List.from(json['orders'] ?? []).map((e) => Data.fromJson(e)).toList();
//    data = List.from(json['orders'] ?? []).map((e) => Data.fromJson(e)).toList();

//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     // _data['success'] = success;
//     // _data['ordersTotal'] = ordersTotal;
//     _data['data'] = data.map((e) => e.toJson()).toList();
//     return _data;
//   }
// }

//   class Data {
//   OrderInfo? info;
//   String? type;
//   List<CartItem>? cartItems;
//   List<dynamic>? updatedOrderCartItems;
//   int? createdAt;
//   double? subTotal;
//   String? screen;
//   String? status;
//   int? userId;
//   bool? checked;
//   int? split;
//   double? splittedAmount;
//   double? change;
//   double? discount;
//   String? serviceCharges;
//   double? saleTax;
//   double? finalTotal;
//   double? grandTotal;
//   int? isUploaded;
//   double? creditedAmount;
//   List<dynamic>? updatedOrder;
//   String? orderHistory;
//   String? orderDateTime;
//   int? id;

//   Data({
//     this.info,
//     this.type,
//     this.cartItems,
//     this.updatedOrderCartItems,
//     this.createdAt,
//     this.subTotal,
//     this.screen,
//     this.status,
//     this.userId,
//     this.checked,
//     this.split,
//     this.splittedAmount,
//     this.change,
//     this.discount,
//     this.serviceCharges,
//     this.saleTax,
//     this.finalTotal,
//     this.grandTotal,
//     this.isUploaded,
//     this.creditedAmount,
//     this.updatedOrder,
//     this.orderHistory,
//     this.orderDateTime,
//     this.id,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         info: json['info'] != null ? OrderInfo.fromJson(json['info']) : null,
//         type: json['type'],
//         cartItems: json['cartItems'] != null
//             ? List<CartItem>.from(
//                 json['cartItems'].map((x) => CartItem.fromJson(x)))
//             : null,
//         updatedOrderCartItems: json['updatedOrderCartItems'],
//         createdAt: json['createdAt'],
//         subTotal: json['subTotal']?.toDouble(),
//         screen: json['screen'],
//         status: json['status'],
//         userId: json['userId'],
//         checked: json['checked'],
//         split: json['split'],
//         splittedAmount: json['splittedAmount']?.toDouble(),
//         change: json['change']?.toDouble(),
//         discount: json['discount']?.toDouble(),
//         serviceCharges: json['serviceCharges'],
//         saleTax: json['saleTax']?.toDouble(),
//         finalTotal: json['finalTotal']?.toDouble(),
//         grandTotal: json['grandTotal']?.toDouble(),
//         isUploaded: json['isUploaded'],
//         creditedAmount: json['credited_amount']?.toDouble(),
//         updatedOrder: json['updatedOrder'],
//         orderHistory: json['orderHistory'],
//         orderDateTime: json['orderDateTime'],
//         id: json['id'],
//       );

//   Map<String, dynamic> toJson() => {
//         'info': info?.toJson(),
//         'type': type,
//         'cartItems': cartItems != null
//             ? List<dynamic>.from(cartItems!.map((x) => x.toJson()))
//             : null,
//         'updatedOrderCartItems': updatedOrderCartItems,
//         'createdAt': createdAt,
//         'subTotal': subTotal,
//         'screen': screen,
//         'status': status,
//         'userId': userId,
//         'checked': checked,
//         'split': split,
//         'splittedAmount': splittedAmount,
//         'change': change,
//         'discount': discount,
//         'serviceCharges': serviceCharges,
//         'saleTax': saleTax,
//         'finalTotal': finalTotal,
//         'grandTotal': grandTotal,
//         'isUploaded': isUploaded,
//         'credited_amount': creditedAmount,
//         'updatedOrder': updatedOrder,
//         'orderHistory': orderHistory,
//         'orderDateTime': orderDateTime,
//         'id': id,
//       };
// }

// class OrderInfo {
//   String? phone;
//   String? customerName;
//   String? address;
//   String? assignRider;
//   int? waiter;
//   String? tableNo;
//   String? tableId;
//   String? tableLocation;
//   String? type;
//   String? orderNote;
//   String? customerId;
//   String? tableCapacity;
//   String? waiterName;
//   String? branchId;

//   OrderInfo({
//     this.phone,
//     this.customerName,
//     this.address,
//     this.assignRider,
//     this.waiter,
//     this.tableNo,
//     this.tableId,
//     this.tableLocation,
//     this.type,
//     this.orderNote,
//     this.customerId,
//     this.tableCapacity,
//     this.waiterName,
//     this.branchId,
//   });

//   factory OrderInfo.fromJson(Map<String, dynamic> json) => OrderInfo(
//         phone: json['phone'],
//         customerName: json['customerName'],
//         address: json['address'],
//         assignRider: json['assignRider'],
//         waiter: json['waiter'],
//         tableNo: json['table_no'],
//         tableId: json['table_id'],
//         tableLocation: json['table_location'],
//         type: json['type'],
//         orderNote: json['orderNote'],
//         customerId: json['customer_id'],
//         tableCapacity: json['table_capacity'],
//         waiterName: json['waiterName'],
//         branchId: json['branch_id'],
//       );

//   Map<String, dynamic> toJson() => {
//         'phone': phone,
//         'customerName': customerName,
//         'address': address,
//         'assignRider': assignRider,
//         'waiter': waiter,
//         'table_no': tableNo,
//         'table_id': tableId,
//         'table_location': tableLocation,
//         'type': type,
//         'orderNote': orderNote,
//         'customer_id': customerId,
//         'table_capacity': tableCapacity,
//         'waiterName': waiterName,
//         'branch_id': branchId,
//       };
// }

// class CartItem {
//   int? productId;
//   String? companyId;
//   String? branchId;
//   String? categoryId;
//   String? category;
//   String? printerIp;
//   int? kitchenId;
//   String? kitchenName;
//   String? productCode;
//   String? title;
//   String? productImage;
//   String? favouriteItem;
//   String? appUrl;
//   double? price;
//   String? createdAt;
//   String? updatedAt;
//   List<Variations>? variations;
//   List<AddOn>? addOn;
//   int? qty;
//   int? additionalItem;
//   List<ProductVariation>? productVariation;

//   CartItem({
//     this.productId,
//     this.companyId,
//     this.branchId,
//     this.categoryId,
//     this.category,
//     this.printerIp,
//     this.kitchenId,
//     this.kitchenName,
//     this.productCode,
//     this.title,
//     this.productImage,
//     this.favouriteItem,
//     this.appUrl,
//     this.price,
//     this.createdAt,
//     this.updatedAt,
//     this.variations,
//     this.addOn,
//     this.qty,
//     this.additionalItem,
//     this.productVariation,
//   });

//   factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
//         productId: json['product_id'],
//         companyId: json['company_id'],
//         branchId: json['branch_id'],
//         categoryId: json['category_id']?.toString(),
//         category: json['category'],
//         printerIp: json['printer_ip'],
//         kitchenId: json['kitchen_id'],
//         kitchenName: json['kitchen_name'],
//         productCode: json['product_code'],
//         title: json['title'],
//         productImage: json['product_image'],
//         favouriteItem: json['favourite_item'],
//         appUrl: json['app_url'],
//         price: (json['price'] is int)
//             ? (json['price'] as int).toDouble()
//             : (json['price'] is String)
//                 ? double.tryParse(json['price']) ?? 0.0
//                 : json['price'],
//         createdAt: json['created_at'],
//         updatedAt: json['updated_at'],
//         variations: json['variations'] != null
//             ? List<Variations>.from(
//                 json['variations'].map((x) => Variations.fromJson(x)))
//             : [],
//         addOn: json['add_on'] != null
//             ? List<AddOn>.from(json['add_on'].map((x) => AddOn.fromJson(x)))
//             : [],
//         qty: json['qty'],
//         additionalItem: json['additional_item'],
//         productVariation: json['product_variation'] != null
//             ? List<ProductVariation>.from(
//                 json['product_variation'].map((x) => ProductVariation.fromJson(x)))
//             : [],
//       );

//   Map<String, dynamic> toJson() => {
//         'product_id': productId,
//         'company_id': companyId,
//         'branch_id': branchId,
//         'category_id': categoryId,
//         'category': category,
//         'printer_ip': printerIp,
//         'kitchen_id': kitchenId,
//         'kitchen_name': kitchenName,
//         'product_code': productCode,
//         'title': title,
//         'product_image': productImage,
//         'favourite_item': favouriteItem,
//         'app_url': appUrl,
//         'price': price,
//         'created_at': createdAt,
//         'updated_at': updatedAt,
//         'variations':
//             variations != null ? variations!.map((x) => x.toJson()).toList() : [],
//         'add_on': addOn != null ? addOn!.map((x) => x.toJson()).toList() : [],
//         'qty': qty,
//         'additional_item': additionalItem,
//         'product_variation': productVariation != null
//             ? productVariation!.map((x) => x.toJson()).toList()
//             : [],
//       };
// }

// class ProductVariation {
//   int? variationId;
//   String? productId;
//   String? variationName;
//   double? variationPrice;
//   String? createdAt;
//   String? updatedAt;

//   ProductVariation({
//     this.variationId,
//     this.productId,
//     this.variationName,
//     this.variationPrice,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory ProductVariation.fromJson(Map<String, dynamic> json) => ProductVariation(
//         variationId: json['variation_id'],
//         productId: json['product_id'],
//         variationName: json['variation_name'],
//         variationPrice: json['variation_price'] is String
//             ? double.tryParse(json['variation_price']) ?? 0.0
//             : (json['variation_price'] as num?)?.toDouble(),
//         createdAt: json['created_at'],
//         updatedAt: json['updated_at'],
//       );

//   Map<String, dynamic> toJson() => {
//         'variation_id': variationId,
//         'product_id': productId,
//         'variation_name': variationName,
//         'variation_price': variationPrice,
//         'created_at': createdAt,
//         'updated_at': updatedAt,
//       };
// }

// class AddOn {
//   int? addOnId;
//   String? productId;
//   String? addOnName;
//   double? addOnPrice;
//   String? createdAt;
//   String? updatedAt;
//   int? quantity;

//   AddOn({
//     this.addOnId,
//     this.productId,
//     this.addOnName,
//     this.addOnPrice,
//     this.createdAt,
//     this.updatedAt,
//     this.quantity,
//   });

//   factory AddOn.fromJson(Map<String, dynamic> json) => AddOn(
//         addOnId: json['add_on_id'],
//         productId: json['product_id']?.toString(),
//         addOnName: json['add_on_name'],
//         addOnPrice: (json['add_on_price'] is int)
//             ? (json['add_on_price'] as int).toDouble()
//             : (json['add_on_price'] is String)
//                 ? double.tryParse(json['add_on_price']) ?? 0.0
//                 : json['add_on_price'],
//         createdAt: json['created_at'],
//         updatedAt: json['updated_at'],
//         quantity: json['quantity'],
//       );

//   Map<String, dynamic> toJson() => {
//         'add_on_id': addOnId,
//         'product_id': productId,
//         'add_on_name': addOnName,
//         'add_on_price': addOnPrice,
//         'created_at': createdAt,
//         'updated_at': updatedAt,
//         'quantity': quantity,
//       };
// }

// class Variations {
//   Variations({
//     required this.variationName,
//     required this.variationPrice,
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   final String variationName;
//   final String variationPrice; // JSON shows "450" (String)
//   final int id; // JSON shows 1239 (int)
//   final String createdAt;
//   final String updatedAt;

//   factory Variations.fromJson(Map<String, dynamic> json) {
//     return Variations(
//       variationName: json['variation_name'] as String,
//       variationPrice: json['variation_price'] as String,
//       id:
//           json['variation_id'] != null
//               ? json['variation_id'] as int
//               : json['id'] as int,
//       createdAt: json['created_at'] as String,
//       updatedAt: json['updated_at'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'variation_name': variationName,
//       'variation_price': variationPrice,
//       'variation_id': id, // Match JSON key in response
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//     };
//   }
// }

// ........................................................................
class OrderListModel {
  final String? type;
  final int? userId;
  final List<Data>? data;

  OrderListModel({
    required this.type,
    required this.userId,
    required this.data,
  });

  factory OrderListModel.fromJson(dynamic json) {
    return OrderListModel(
      type: json['type'] ?? '',
      userId:
          json['userId'] is int
              ? json['userId']
              : int.tryParse(
                json['userId'].toString(),
              ), // handles string or int safely
      data:
          (json['orders'] as List<dynamic>?)?.map((e) {
            print('*****************Parsing order item********************: $e');
            return Data.fromJson(e);
          }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'userId': userId,
      'orders': data?.map((e) => e.toJson()).toList(),
    };
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
  final dynamic subTotal;
  final String status;
  final int userId;
  final int id;
  final String? orderId;
  final dynamic grandTotal;
  final dynamic finalTotal;
  final dynamic discount;
  final dynamic change; // Changed to nullable double?
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
      waiter: json['waiter'] as int?,
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
  final Variations? variations;
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
      addOn:
          List.from(
            json['add_on'] ?? [],
          ).map((e) => AddOn.fromJson(e)).toList(),
      variations:
          json['variations'] is Map && json['variations'] != null
              ? Variations.fromJson(json['variations'])
              : null,
      productId: json['product_id'],

      category: json['category'] as String?,
      productVariation:
          json['product_variation'] is Map && json['product_variation'] != null
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
      'variations': variations?.toJson(),
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

  final int? addOnId;
  final String? productId;
  final String? addOnName;
  final String? addOnPrice;
  final String? createdAt;
  final String? updatedAt;

  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(
      addOnId: json['add_on_id'] as int?,
      productId: json['product_id'] as String?,
      addOnName: json['add_on_name'] as String?,
      addOnPrice: json['add_on_price'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'add_on_id': addOnId,
      'product_id': productId,
      'add_on_name': addOnName,
      'add_on_price': addOnPrice,
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
      id:
          json['variation_id'] != null
              ? json['variation_id'] as int
              : json['id'] as int,
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
      variationPrice: json['variation_price'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      id:
          json['variation_id'] != null
              ? json['variation_id'] as int
              : json['id'] as int,
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

// class UpdatedOrderCartItem {
//   final List<CartItem> cartItems;
//   final String? updatedAt;
//
//   UpdatedOrderCartItem({required this.cartItems, this.updatedAt});
//
//   factory UpdatedOrderCartItem.fromJson(Map<String, dynamic> json) {
//     return UpdatedOrderCartItem(
//       cartItems: List.from(json['cartItems']).map((e) => CartItem.fromJson(e)).toList(),
//       updatedAt: json['updatedAt'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'cartItems': cartItems.map((e) => e.toJson()).toList(),
//       'updatedAt': updatedAt,
//     };
//   }
// }
