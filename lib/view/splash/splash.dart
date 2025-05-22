import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_bloc.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_event.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_state.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/routes/routes_name.dart';

 class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  LoginState? _latestLoginState;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 4500),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // Trigger your login event once after a 2 second delay
    Future.delayed(const Duration(seconds: 2), () {
      context.read<LoginBloc>().add(LoadInitialData());
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _latestLoginState != null) {
        _navigateAfterAnimation(_latestLoginState!);
      }
    });
  }

  void _navigateAfterAnimation(LoginState state) {
    if (state.loginStatus == LoginStatus.success && state.userModel != null) {
      Navigator.pushNamedAndRemoveUntil(context, RoutesName.navBar, (route) => false);
    } else if (state.loginStatus == LoginStatus.initial || state.loginStatus == LoginStatus.error) {
      Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        _latestLoginState = state;
      },
      child: Scaffold(
        backgroundColor: AppColors.customScaffoldColor,
        body: Center(
          child: FadeTransition(
            opacity: _animation,
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/png/Systemize-pos_icon.png',
                height: 200,
                width: 200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
