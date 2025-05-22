import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCategoryBox extends StatelessWidget {
  final Color? boxColor;
  final double? height;
  final double? width;
  final String text;
  final Color? textColor;
  final VoidCallback onTap;

  const CustomCategoryBox({
    super.key,
    this.boxColor,
    required this.text,
    this.textColor,
    this.height,
    this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      splashColor: Colors.white.withValues(alpha: 0.1),
      highlightColor: Colors.white.withValues(alpha: 0.05),
      child: Ink(
        height: height ?? 45,
        width: width ?? 110,
        decoration: BoxDecoration(
          color: boxColor ?? Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
