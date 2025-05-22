import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemize_pos/bloc/product_bloc/product_event.dart';
import 'package:systemize_pos/bloc/product_bloc/product_state.dart';
import 'package:systemize_pos/data/models/hive_model/products_model.dart';
import 'package:systemize_pos/data/services/api_service.dart';
import 'package:systemize_pos/utils/app_url.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc()
    : super(
        ProductState(
          categories: [],
          selectedCategory: 'All',
          searchQuery: '',
          filteredProducts: [],
          message: '',
          tappedIndex: null,
        ),
      ) {
    on<ProductApi>(_productApi);
    on<UpdateSearchQuery>(_onUpdateSearchQuery);
    on<SelectCategory>(_onSelectCategory);
    on<TapProduct>(_onTapProduct);
  }

  void _onUpdateSearchQuery(
    UpdateSearchQuery event,
    Emitter<ProductState> emit,
  ) {
    final query = event.query.toLowerCase();
    final allProducts = state.productsData?.data?.products ?? [];

    // First filter by selected category
    final categoryFiltered =
        state.selectedCategory == 'All'
            ? allProducts
            : allProducts
                .where((p) => p.category == state.selectedCategory)
                .toList();

    // Then apply the search query
    final filtered =
        categoryFiltered.where((p) {
          return p.title?.toLowerCase().contains(query) ?? false;
        }).toList();

    emit(state.copyWith(searchQuery: query, filteredProducts: filtered));
  }

  void _onSelectCategory(SelectCategory event, Emitter<ProductState> emit) {
    final selected = event.category;
    final allProducts = state.productsData?.data?.products ?? [];

    // First filter by categorya
    final categoryFiltered =
        selected == 'All'
            ? allProducts
            : allProducts.where((p) => p.category == selected).toList();

    // Then apply existing search query (if any)
    final query = state.searchQuery.toLowerCase();
    final filtered =
        categoryFiltered.where((p) {
          return p.title?.toLowerCase().contains(query) ?? false;
        }).toList();

    emit(
      state.copyWith(selectedCategory: selected, filteredProducts: filtered),
    );
  }

  void _productApi(ProductApi event, Emitter<ProductState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final bool alreadyFetched = prefs.getBool('productsFetched') ?? false;

    if (alreadyFetched && !event.forceRefresh) {
      // Load from Hive only
      final box = await Hive.openBox<ProductsModel>('productsBox');
      final cachedData = box.get('products');
      if (cachedData != null) {
        final productList = cachedData.data?.products ?? [];
        final categories =
            productList
                .map((p) => p.category)
                .whereType<String>()
                .toSet()
                .toList();
        categories.insert(0, 'All');

        emit(
          state.copyWith(
            productStatus: ProductStatus.success,
            message: 'Loaded from local cache',
            productsData: cachedData,
            categories: categories,
            filteredProducts: productList,
            selectedCategory: 'All',
          ),
        );
      } else {
        emit(
          state.copyWith(
            productStatus: ProductStatus.error,
            message: 'No cached data available.',
          ),
        );
      }
      return;
    }

    // Fetch from API
    emit(state.copyWith(productStatus: ProductStatus.loading));
    final box = await Hive.openBox<ProductsModel>('productsBox');

    await ApiService.getMethod(
      authHeader: true,
      apiUrl: getProducts,
      executionMethod: (bool success, dynamic responseData) {
        if (success) {
          ProductsModel productsModel = ProductsModel.fromJson(responseData);
          box.put('products', productsModel);
          prefs.setBool('productsFetched', true); // 👈 Save flag

          final productList = productsModel.data?.products ?? [];
          final categories =
              productList
                  .map((p) => p.category)
                  .whereType<String>()
                  .toSet()
                  .toList();
          categories.insert(0, 'All');

          emit(
            state.copyWith(
              productStatus: ProductStatus.success,
              message: 'Products fetched successfully',
              productsData: productsModel,
              categories: categories,
              filteredProducts: productList,
              selectedCategory: 'All',
            ),
          );
        } else {
          final cachedData = box.get('products');
          if (cachedData != null) {
            final productList = cachedData.data?.products ?? [];
            final categories =
                productList
                    .map((p) => p.category)
                    .whereType<String>()
                    .toSet()
                    .toList();
            categories.insert(0, 'All');

            emit(
              state.copyWith(
                productStatus: ProductStatus.success,
                message: 'Loaded from cache',
                productsData: cachedData,
                categories: categories,
                filteredProducts: productList,
                selectedCategory: 'All',
              ),
            );
          } else {
            emit(
              state.copyWith(
                productStatus: ProductStatus.error,
                message: responseData['message'] ?? 'Fetching failed',
              ),
            );
          }
        }
      },
    );
  }

  void _onTapProduct(TapProduct event, Emitter<ProductState> emit) async {
    emit(state.copyWith(tappedIndex: event.index));
    // Wait some time to show animation
    await Future.delayed(Duration(milliseconds: 100));

    emit(state.copyWith(tappedIndex: null));
  }

}
