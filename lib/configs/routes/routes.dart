import 'package:flutter/material.dart';
import 'package:systemize_pos/configs/routes/routes_name.dart';
import 'package:systemize_pos/configs/widgets/custom_navbar.dart';
import 'package:systemize_pos/view/auth/login.dart';
import 'package:systemize_pos/view/splash/splash.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );

      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return Scaffold();
          },
        );
         case RoutesName.navBar:
        return MaterialPageRoute(
          builder: (BuildContext context) => CustomBottomNavBar(),
        );

      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(child: Text('No route defined')),
            );
          },
        );
    }
  }
}
