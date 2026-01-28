import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isSmallScreen(BuildContext context) {
    return getScreenWidth(context) < 600;
  }

  static bool isMediumScreen(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= 600 && width < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return getScreenWidth(context) >= 1200;
  }

  static bool isTablet(BuildContext context) {
    final width = getScreenWidth(context);
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= 1200;
  }

  static double getAdaptiveFontSize(BuildContext context, {
    required double small,
    double? medium,
    double? large,
  }) {
    if (isSmallScreen(context)) return small;
    if (isMediumScreen(context)) return medium ?? small * 1.2;
    return large ?? small * 1.5;
  }

  static double getAdaptivePadding(BuildContext context, {
    required double small,
    double? medium,
    double? large,
  }) {
    if (isSmallScreen(context)) return small;
    if (isMediumScreen(context)) return medium ?? small * 1.3;
    return large ?? small * 1.8;
  }

  static double getAdaptiveSpacing(BuildContext context, {
    required double small,
    double? medium,
    double? large,
  }) {
    if (isSmallScreen(context)) return small;
    if (isMediumScreen(context)) return medium ?? small * 1.2;
    return large ?? small * 1.5;
  }

  static int getGridColumns(BuildContext context) {
    if (isSmallScreen(context)) return 4;
    if (isMediumScreen(context)) return 5;
    return 6;
  }

  static double getButtonFontSize(BuildContext context) {
    if (isSmallScreen(context)) return 18;
    if (isMediumScreen(context)) return 20;
    return 22;
  }

  static double getDisplayFontSize(BuildContext context) {
    if (isSmallScreen(context)) return 32;
    if (isMediumScreen(context)) return 40;
    return 48;
  }

  static double getExpressionFontSize(BuildContext context) {
    if (isSmallScreen(context)) return 16;
    if (isMediumScreen(context)) return 20;
    return 24;
  }

  static EdgeInsets getDisplayPadding(BuildContext context) {
    final horizontal = getAdaptivePadding(context, small: 16, medium: 24, large: 32);
    final vertical = getAdaptivePadding(context, small: 12, medium: 16, large: 20);
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static EdgeInsets getKeyboardPadding(BuildContext context) {
    final padding = getAdaptivePadding(context, small: 8, medium: 12, large: 16);
    return EdgeInsets.all(padding);
  }

  static double getKeyboardSpacing(BuildContext context) {
    return getAdaptiveSpacing(context, small: 6, medium: 8, large: 10);
  }

  static double getBorderRadius(BuildContext context) {
    if (isSmallScreen(context)) return 10;
    if (isMediumScreen(context)) return 12;
    return 14;
  }

  static int getDisplayFlex(BuildContext context) {
    if (isSmallScreen(context)) return 1;
    if (isMediumScreen(context)) return 1;
    return 1;
  }

  static int getGraphFlex(BuildContext context) {
    if (isSmallScreen(context)) return 2;
    if (isMediumScreen(context)) return 3;
    return 3;
  }

  static int getKeyboardFlex(BuildContext context) {
    if (isSmallScreen(context)) return 3;
    if (isMediumScreen(context)) return 4;
    return 4;
  }
}
