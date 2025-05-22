import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_bloc.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_event.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_state.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/routes/routes_name.dart';
import 'package:systemize_pos/configs/widgets/custom_formfield.dart';
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.customScaffoldColor,
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(80.0),
        //   // Set the desired height
        //   child: AppBar(
        //     surfaceTintColor: Colors.transparent,
        //     backgroundColor: Colors.transparent,
        //     // flexibleSpace: CustomPaint(
        //     //   size: const Size(double.infinity, 80),
        //     //   painter: CustomTopGradient(),
        //     // ),
        //   ),
        // ),
        // bottomNavigationBar: CustomPaint(
        //   size: const Size(double.infinity, 80),
        //   painter: CustomBottomGradient(),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: context.screenHeight * .2),
              Image.asset(
                'assets/png/Systemize-pos_icon.png',
                // height: 150,
                width: 180,
                // fit: BoxFit.cover,
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
                      // Text(
                      //   'Email',
                      //   style: state.labelText,
                      // ),
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
                      // Text(
                      //   'Password',
                      //   style: state.labelText,
                      // ),
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
                          // if (value!.length < 8) {
                          //   return ErrorStrings.passwordMust;
                          // }

                          return null;
                        },
                        textEditingController: _passwordController,
                        textInputType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      // SizedBox(height: Get.height * .012),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: GestureDetector(
                      //     onTap: () {},
                      //     child: Text(
                      //       'Forget Password?',
                      //       style: state.labelText,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: context.screenHeight * .05),
                      BlocListener<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state.loginStatus == LoginStatus.error) {
                            CustomSnackbar.show(
                              context: context,
                              message: 'Invaild Credentials',
                              icon: Icons.error,
                            );  
                          } else if (state.loginStatus == LoginStatus.success) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RoutesName.navBar,
                              (route) => false,
                            );
                          }
                        },
                        child: Center(
                          child: BlocBuilder<LoginBloc, LoginState>(
                            buildWhen:
                                (previous, current) =>
                                    previous.loginStatus != current.loginStatus,
                            builder: (context, state) {
                              return CustomButton(
                                title:
                                    state.loginStatus == LoginStatus.loading
                                        ? 'Loading...'
                                        : 'Login',
                                onTap:
                                    state.loginStatus == LoginStatus.loading
                                        ? null // Disable button during loading
                                        : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context.read<LoginBloc>().add(
                                              LoginApi(
                                                emailController:
                                                    _emailController,
                                                passwordController:
                                                    _passwordController,
                                              ),
                                            );
                                          }
                                        },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // Center(
                      //   child: Text(
                      //     'If you don’t have an account,',
                      //     style: TextStyle(
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.w400,
                      //       color: AppColors.customlabeltextColor,
                      //     ),
                      //   ),
                      // ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'You Can ',
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w400,
                      //         color: AppColors.customlabeltextColor,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         // Get.off(() => SignupPage());
                      //       },
                      //       child: Text(
                      //         'Request For a Service',
                      //         style: TextStyle(
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w600,
                      //           color: AppColors.customThemeColor,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
       
            ],
          ),
        ),
      ),
    );
  }
}
