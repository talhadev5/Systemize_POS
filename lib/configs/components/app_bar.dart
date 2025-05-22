import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:systemize_pos/configs/color/color.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key, this.text, this.leading, this.icon, this.actions});
  Widget? leading;
  // ignore: prefer_typing_uninitialized_variables
  final actions;
  String? text;
  final IconData? icon;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 1,
      backgroundColor: AppColors.customWhiteColor,
      leading: leading,
      title: Text(
        text.toString(),
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.customThemeColor,
          ),
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }
}
