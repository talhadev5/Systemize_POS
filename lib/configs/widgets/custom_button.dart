import 'package:flutter/material.dart';

import '../color/color.dart';

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Gradient? gradient;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.height = 55,
    this.borderRadius = 15,
    this.backgroundColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color:
              gradient == null
                  ? (backgroundColor ?? AppColors.customThemeColor)
                  : null,
          gradient: gradient,
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.customWhiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
