import 'package:flutter/material.dart';

import '../color/color.dart';


class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [
                  AppColors.customThemeLightColor,
                  AppColors.customThemeColor
                ], // Replace with actual gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.customWhiteColor),
            ),
          ),
        ));
  }
}
