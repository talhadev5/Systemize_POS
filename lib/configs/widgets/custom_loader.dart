import 'package:flutter/material.dart';
import 'package:systemize_pos/configs/color/color.dart';

class CustomLoader extends StatelessWidget {
  final double size;
  final Color color;

  const CustomLoader({
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
