import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_bloc.dart';
import 'package:systemize_pos/bloc/cart_bloc/cart_bloc.dart';
import 'package:systemize_pos/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:systemize_pos/bloc/order_list_bloc/order_list_bolc.dart';
import 'package:systemize_pos/bloc/product_bloc/product_bloc.dart';
import 'package:systemize_pos/bloc/product_details_bloc/product_details_bloc.dart';
import 'package:systemize_pos/bloc/profile_bloc/profile_bloc.dart';
import 'package:systemize_pos/bloc/web_socket_bloc/web_socket_bloc.dart';
import 'package:systemize_pos/data/repositories/order_list_repo/order_list_repo.dart';

// Import all your BLoCs and Cubits

class MultiBlocProviders {
  static List<BlocProvider> get providers => [
    // Auth BLoCs..........
    BlocProvider<LoginBloc>(create: (context) => LoginBloc()),

    // Add more blocs here
    BlocProvider<BottomNavBloc>(create: (context) => BottomNavBloc()),
    BlocProvider<ProductBloc>(create: (context) => ProductBloc()),
    BlocProvider<ProductDetailBloc>(create: (context) => ProductDetailBloc()),
    BlocProvider<CartBloc>(create: (context) => CartBloc()),
    BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
    BlocProvider<WebSocketSettingsBloc>( create: (context) => WebSocketSettingsBloc()),
    BlocProvider<OrderListBloc>( create: (context) => OrderListBloc(repository: OrderRepository())),
  ];
}
