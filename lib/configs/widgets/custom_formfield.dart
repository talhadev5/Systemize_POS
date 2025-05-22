import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:systemize_pos/configs/color/color.dart';


// ignore: must_be_immutable
class CustomFormField extends StatefulWidget {
  CustomFormField(
      {super.key,
      this.prefixIcon,
      required this.helperText,
      required this.validator,
      required this.textEditingController,
      required this.textInputType,
      this.obscureText,
      this.onTap});
  final String helperText;
  // final String hint;
  final Function(String?)? validator;
  final TextInputType textInputType;
  bool? obscureText;
  final Widget? prefixIcon;
  final TextEditingController textEditingController;
  final VoidCallback? onTap;

  @override
  // ignore: no_logic_in_create_state
  State<CustomFormField> createState() => _CustomFormFieldState(prefixIcon);
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool hidePassword = true;
  final Widget? prefixIcon;

  _CustomFormFieldState(this.prefixIcon);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        strutStyle: const StrutStyle(height: 0, forceStrutHeight: true),
        style: const TextStyle(fontSize: 14, color: AppColors.customBlackColor),
        obscureText: widget.obscureText ?? false,
        controller: widget.textEditingController,
        keyboardType: widget.textInputType,
        validator: (value) => widget.validator!(value),
        cursorColor: AppColors.customThemeColor,
        showCursor: true,
        decoration: InputDecoration(
            suffixIcon: widget.obscureText != null
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        // hidePassword = !hidePassword;
                        widget.obscureText = !widget.obscureText!;
                      });
                    },
                    child: Icon(
                      widget.obscureText!
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: widget.obscureText!
                          ? AppColors.customlabeltextColor
                          : AppColors.customThemeColor,
                    ),
                  )
                : const SizedBox(),
            prefixIcon: prefixIcon,
            fillColor: AppColors.customWhiteColor,
            prefixIconColor: AppColors.customThemeColor,
            filled: true,
            label: Text(widget.helperText),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.customThemeColor),
            labelStyle: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.customlabeltextColor),
            // hintStyle: GoogleFonts.roboto(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w400,
            //     color: AppColors.customlabeltextColor),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            focusColor: AppColors.customWhiteColor,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    const BorderSide(color: AppColors.customThemeColor)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.black26)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.red))));
  }
}
