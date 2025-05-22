import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_bloc.dart';
import 'package:systemize_pos/bloc/navbar_bloc/navbar_bloc.dart';
import 'package:systemize_pos/bloc/product_bloc/product_bloc.dart';
import 'package:systemize_pos/bloc/product_details_bloc/product_details_bloc.dart';

// Import all your BLoCs and Cubits

class MultiBlocProviders {
  static List<BlocProvider> get providers => [
    // Auth BLoCs..........
    BlocProvider<LoginBloc>(create: (context) => LoginBloc()),

    // Add more blocs here
    BlocProvider<BottomNavBloc>(create: (context) => BottomNavBloc()),
    BlocProvider<ProductBloc>(create: (context) => ProductBloc()),
    BlocProvider<ProductDetailBloc>(create: (context) => ProductDetailBloc()),
  ];
}
