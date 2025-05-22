import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/widgets/custom_button.dart';
import 'package:systemize_pos/configs/widgets/custom_formfield.dart';
import 'package:systemize_pos/utils/constant.dart';
import 'package:systemize_pos/utils/extensions/media_query_extensions.dart';

// ignore: must_be_immutable
class SignupPage extends StatelessWidget {
  SignupPage({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      backgroundColor: AppColors.customScaffoldColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        flexibleSpace: CustomPaint(
          size: const Size(double.infinity, 80),
          // painter: CustomTopGradient(),
        ),
      ),
      bottomNavigationBar: CustomPaint(
        size: const Size(double.infinity, 80),
        // painter: CustomBottomGradient(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/png/Systemize-pos_icon.png',
              // fit: BoxFit.cover,
              // height: 130,
              width: 180,
            ),
            Text(
              'Request For Service',
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  fontSize: 22,
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
                    SizedBox(height: context.screenHeight * .035),
                    // const SizedBox(height: 12.0),
                    // Text(
                    //   'Name',
                    //   style: state.labelText,
                    // ),
                    // const SizedBox(height: 8.0),
                    CustomFormField(
                      prefixIcon: const Icon(
                        CupertinoIcons.person,
                        color: AppColors.customlabeltextColor,
                      ),
                      helperText: 'Full Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ErrorStrings.nameReq;
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Please enter a valid name';
                        }
                        if (value.length < 3) {
                          return 'Name must be at least 3 characters long';
                        }
                        return null;
                      },
                      textEditingController: nameController,
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: context.screenHeight * .025),
                    // const SizedBox(height: 12.0),
                    // Text(
                    //   'Email',
                    //   style: state.labelText,
                    // ),
                    // const SizedBox(height: 8.0),
                    CustomFormField(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.customlabeltextColor,
                      ),
                      helperText: 'email@gmail.com',
                      validator: (value) {
                        if ((value ?? "").isEmpty) {
                          return ErrorStrings.emailReq;
                        }

                        return ErrorStrings.emailInvalid;
                      },
                      textEditingController: emailController,
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: context.screenHeight * .025),
                    // const SizedBox(height: 12.0),
                    // Text(
                    //   'Phone',
                    //   style: state.labelText,
                    // ),
                    // const SizedBox(height: 8.0),
                    CustomFormField(
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: AppColors.customlabeltextColor,
                      ),
                      helperText: '03001234567',
                      validator: (value) {
                        if ((value ?? "").isEmpty) {
                          return 'Phone number cannot be empty';
                        }
                        if (value?.length != 11) {
                          return 'Phone number must be exactly 11 digits';
                        }
                        if (!RegExp(r'^03\d{9}$').hasMatch(value!)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      textEditingController: phoneController,
                      textInputType: TextInputType.number,
                      // inputFormatters: [
                      //   // Restrict input to 11 digits
                      //   FilteringTextInputFormatter.digitsOnly,
                      //   LengthLimitingTextInputFormatter(11),
                      // ],
                    ),

                    SizedBox(height: context.screenHeight * .025),
                    // const SizedBox(height: 12.0),
                    // Text(
                    //   'Company',
                    //   style: state.labelText,
                    // ),
                    // const SizedBox(height: 8.0),
                    CustomFormField(
                      prefixIcon: const Icon(
                        CupertinoIcons.building_2_fill,
                        color: AppColors.customlabeltextColor,
                      ),
                      helperText: 'Company Name Here',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ErrorStrings.nameReq;
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Please enter a valid company name';
                        }
                        if (value.length < 3) {
                          return 'Name must be at least 3 characters long';
                        }
                        return null;
                      },
                      textEditingController: companyController,
                      textInputType: TextInputType.name,
                    ),
                    SizedBox(height: context.screenHeight * .025),
                    // const SizedBox(height: 12.0),
                    // Text(
                    //   'Address',
                    //   style: state.labelText,
                    // ),
                    // const SizedBox(height: 8.0),
                    CustomFormField(
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.customlabeltextColor,
                      ),
                      helperText: 'Address 123, Pakistan',
                      validator: (value) {
                        if ((value ?? "").isEmpty) {
                          return ErrorStrings.notEmpty;
                        }

                        return null;
                      },
                      textEditingController: addressController,
                      textInputType: TextInputType.streetAddress,
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: CustomButton(
                        title: 'Sign up',
                        onTap: () {
                          // logic.registerUserMethod();
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: Text(
                        'If already have an account,',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.customlabeltextColor,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You Can ',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.customlabeltextColor,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Get.off(() => LoginPage());
                          },
                          child: Text(
                            'Login Here!',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.customThemeColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .12),
          ],
        ),
      ),
    );
  }
}
