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
  final double size;
  final Color color;
  final double strokeWidth;

  const CustomLoader({
    super.key,
    this.size = 50.0,
    this.color = Colors.blue,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
