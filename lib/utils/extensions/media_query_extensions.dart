import 'package:flutter/material.dart';

extension MediaQueryValues on BuildContext {
  // Screen dimensions
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // Safe area paddings
  double get topPadding => MediaQuery.paddingOf(this).top;
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;
  double get leftPadding => MediaQuery.paddingOf(this).left;
  double get rightPadding => MediaQuery.paddingOf(this).right;

  // Keyboard height
  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;

  // Orientation
  Orientation get orientation => MediaQuery.orientationOf(this);
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  // Device type
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;
}
