import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:systemize_pos/configs/color/color.dart';

class DefultLoader extends StatelessWidget {
  final double size;
  final Color color;

  const DefultLoader({
    super.key,
    this.size = 24.0,
    this.color = AppColors.customThemeColor, // Default spinner color
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}

// custom loder.............

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
          Platform.isAndroid
              ? Center(
                child: Card(
                  color: AppColors.customWhiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const SizedBox(
                          width: 40, // Adjust size
                          height: 40,
                          child: CircularProgressIndicator(
                            color: AppColors.customThemeColor,
                          ),
                        ),
                        Icon(
                          Icons.restaurant_menu,
                          size: 25,
                          color: AppColors.customThemeColor,
                        ),
                        // Image.asset(
                        //   AppImages.loadingLogo,
                        //   height: 30,
                        //   width: 25,
                        //   color: AppColors.customThemeColor,
                        // )
                      ],
                    ),
                  ),
                ),
              )
              : const Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                  color: Colors.black,
                ),
              ),
    );
  }
}
