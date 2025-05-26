import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_bloc.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_event.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_state.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/routes/routes_name.dart';
import 'package:systemize_pos/configs/widgets/custom_formfield.dart';
import 'package:systemize_pos/configs/widgets/custom_loader.dart';
import 'package:systemize_pos/configs/widgets/custom_sankbar.dart';
import 'package:systemize_pos/utils/constant.dart';
import 'package:systemize_pos/utils/extensions/media_query_extensions.dart';

import '../../configs/widgets/custom_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.customScaffoldColor,
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: context.screenHeight * .2),
                      Image.asset(
                        'assets/png/Systemize-pos_icon.png',
                        width: 180,
                      ),
                      Text(
                        'Welcome Back!',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppColors.customThemeColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: context.screenHeight * .025),
                              CustomFormField(
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: AppColors.customlabeltextColor,
                                ),
                                helperText: 'Enter Email',
                                validator: (value) {
                                  if ((value ?? "").isEmpty) {
                                    return ErrorStrings.emailReq;
                                  } else if (!RegExp(
                                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                                  ).hasMatch(value!)) {
                                    return ErrorStrings.emailInvalid;
                                  }
                                  return null;
                                },
                                textEditingController: _emailController,
                                textInputType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: context.screenHeight * .025),
                              CustomFormField(
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.customlabeltextColor,
                                ),
                                helperText: 'Enter Password',
                                validator: (value) {
                                  if ((value ?? "").isEmpty) {
                                    return ErrorStrings.passwordReq;
                                  }
                                  return null;
                                },
                                textEditingController: _passwordController,
                                textInputType: TextInputType.visiblePassword,
                                obscureText: true,
                              ),
                              SizedBox(height: context.screenHeight * .05),
                              BlocListener<LoginBloc, LoginState>(
                                listener: (context, state) {
                                  if (state.loginStatus == LoginStatus.error) {
                                    CustomSnackbar.show(
                                      context: context,
                                      message: 'Invalid Credentials',
                                      icon: Icons.error,
                                    );
                                  } else if (state.loginStatus ==
                                      LoginStatus.success) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RoutesName.navBar,
                                      (route) => false,
                                    );
                                  }
                                },
                                child: Center(
                                  child: CustomButton(
                                    title: 'Login',
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<LoginBloc>().add(
                                          LoginApi(
                                            emailController: _emailController,
                                            passwordController:
                                                _passwordController,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Show loader if loading
                if (state.loginStatus == LoginStatus.loading)
                  CustomLoader(color: AppColors.customThemeColor),
              ],
            );
          },
        ),
      ),
    );
  }
}
