import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/providers/multi_bloc_provider.dart';
import 'package:systemize_pos/configs/routes/routes.dart';
import 'package:systemize_pos/configs/routes/routes_name.dart';
import 'package:systemize_pos/data/models/hive_model/products_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.customThemeColor, // Your desired color
      statusBarIconBrightness: Brightness.light, // Light icons on dark bar
    ),
  );

  await Hive.initFlutter();
  Hive.registerAdapter(ProductsModelAdapter());
  Hive.registerAdapter(DataAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(VariationAdapter());
  Hive.registerAdapter(AddOnAdapter());

  await Hive.openBox<ProductsModel>('productsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: MultiBlocProviders.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Systemize',
        theme: ThemeData(
          // This is the theme of your application.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        // home: SplashScreen(),
        initialRoute: RoutesName.splash, // Initial route
        onGenerateRoute: Routes.generateRoute, //
      ),
    );
  }
}
