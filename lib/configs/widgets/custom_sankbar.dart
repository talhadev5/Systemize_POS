import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black87,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            GestureDetector(
              onTap: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
              child: Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
      ),
    );

    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
