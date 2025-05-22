import 'package:systemize_pos/data/models/hive_model/products_model.dart';

enum ProductStatus { initial, loading, success, error }

class ProductState {
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;
  final ProductsModel? productsData;
  final List<Product> filteredProducts;
  final String message;
  final ProductStatus productStatus;
  final int? tappedIndex;

  ProductState({
    required this.categories,
    required this.selectedCategory,
    required this.searchQuery,

    this.productsData,
    required this.filteredProducts,
    required this.message,
    this.productStatus = ProductStatus.initial,
    this.tappedIndex,
  });

  factory ProductState.initial() => ProductState(
    categories: [],
    selectedCategory: 'All',
    searchQuery: '',
    productsData: null,
    filteredProducts: [],
    message: '',
    tappedIndex: null,
  );

  ProductState copyWith({
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    ProductsModel? productsData,
    List<Product>? filteredProducts,
    String? message,
    ProductStatus? productStatus,
    int? tappedIndex,
  }) {
    return ProductState(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      productsData: productsData ?? this.productsData,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      message: message ?? this.message,
      productStatus: productStatus ?? this.productStatus,
      tappedIndex: tappedIndex,
    );
  }
}
