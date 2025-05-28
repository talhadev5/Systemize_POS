import 'package:hive/hive.dart';

part 'products_model.g.dart';

@HiveType(typeId: 0)
class ProductsModel extends HiveObject {
  @HiveField(0)
  bool? success;

  @HiveField(1)
  Data? data;

  ProductsModel({this.success, this.data});

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

@HiveType(typeId: 1)
class   Data extends HiveObject {
  @HiveField(0)
  List<Product> products;

  Data({this.products = const []});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        products: json["products"] == null
            ? []
            : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
      );
}

@HiveType(typeId: 2)
class Product extends HiveObject {
  @HiveField(0)
  int? productId;

  @HiveField(1)
  String? companyId;

  @HiveField(2)
  String? branchId;

  @HiveField(3)
  String? categoryId;

  @HiveField(4)
  String? category;

  @HiveField(5)
  String? printerIp;

  @HiveField(6)
  int? kitchenId;

  @HiveField(7)
  String? kitchenName;

  @HiveField(8)
  String? productCode;

  @HiveField(9)
  String? title;

  @HiveField(10)
  String? productImage;

  @HiveField(11)
  String? favouriteItem;

  @HiveField(12)
  String? appUrl;

  @HiveField(13)
  String? price;

  @HiveField(14)
  DateTime? createdAt;

  @HiveField(15)
  DateTime? updatedAt;

  @HiveField(16)
  List<Variation> variations;

  @HiveField(17)
  List<AddOn> addOn;

  Product({
    this.productId,
    this.companyId,
    this.branchId,
    this.categoryId,
    this.category,
    this.printerIp,
    this.kitchenId,
    this.kitchenName,
    this.productCode,
    this.title,
    this.productImage,
    this.favouriteItem,
    this.appUrl,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.variations = const [],
    this.addOn = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        companyId: json["company_id"],
        branchId: json["branch_id"],
        categoryId: json["category_id"],
        category: json["category"],
        printerIp: json["printer_ip"],
        kitchenId: json["kitchen_id"],
        kitchenName: json["kitchen_name"],
        productCode: json["product_code"],
        title: json["title"],
        productImage: json["product_image"],
        favouriteItem: json["favourite_item"],
        appUrl: json["app_url"],
        price: json["price"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
        variations: json["variations"] == null
            ? []
            : List<Variation>.from(json["variations"].map((x) => Variation.fromJson(x))),
        addOn: json["add_on"] == null
            ? []
            : List<AddOn>.from(json["add_on"].map((x) => AddOn.fromJson(x))),
      );
}

@HiveType(typeId: 3)
class Variation extends HiveObject {
  @HiveField(0)
  int? variationId;

  @HiveField(1)
  String? productId;

  @HiveField(2)
  String? variationName;

  @HiveField(3)
  String? variationPrice;

  @HiveField(4)
  DateTime? createdAt;

  @HiveField(5)
  DateTime? updatedAt;

  Variation({
    this.variationId,
    this.productId,
    this.variationName,
    this.variationPrice,
    this.createdAt,
    this.updatedAt,
  });

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        variationId: json["variation_id"],
        productId: json["product_id"],
        variationName: json["variation_name"],
        variationPrice: json["variation_price"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      );
  Map<String, dynamic> toJson() => {  
        "variation_id": variationId,
        "product_id": productId,
        "variation_name": variationName,
        "variation_price": variationPrice,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };   
}

@HiveType(typeId: 4)
class AddOn extends HiveObject {
  @HiveField(0)
  int? addOnId;

  @HiveField(1)
  String? productId;

  @HiveField(2)
  String? addOnName;

  @HiveField(3)
  String? addOnPrice;

  @HiveField(4)
  DateTime? createdAt;

  @HiveField(5)
  DateTime? updatedAt;

  AddOn({
    this.addOnId,
    this.productId,
    this.addOnName,
    this.addOnPrice,
    this.createdAt,
    this.updatedAt,
  });

  factory AddOn.fromJson(Map<String, dynamic> json) => AddOn(
        addOnId: json["addOn_id"],
        productId: json["product_id"],
        addOnName: json["addOn_name"],
        addOnPrice: json["addOn_price"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      );
  Map<String, dynamic> toJson() => {
        "addOn_id": addOnId,
        "product_id": productId,
        "addOn_name": addOnName,
        "addOn_price": addOnPrice,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };    
}
