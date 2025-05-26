import 'package:flutter/material.dart';
import 'package:systemize_pos/configs/routes/routes_name.dart';
import 'package:systemize_pos/configs/widgets/custom_navbar.dart';
import 'package:systemize_pos/view/auth/login.dart';
import 'package:systemize_pos/view/cart/cart_screen.dart';
import 'package:systemize_pos/view/splash/splash.dart';
import 'package:systemize_pos/view/user_profile/order_list/order_list.dart';
import 'package:systemize_pos/view/web_socket/websocket_setting.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );

      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        );

      case RoutesName.navBar:
        return MaterialPageRoute(
          builder: (BuildContext context) => CustomBottomNavBar(),
        );

      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return Scaffold();
          },
        );

      case RoutesName.cartScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => CartScreen(),
        );

      case RoutesName.orderList:
        return MaterialPageRoute(
          builder: (BuildContext context) => OrderListScreen(),
        );

      case RoutesName.webSocketSetting:
        return MaterialPageRoute(
          builder: (BuildContext context) => WebSocketSettingsPage(),
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
