

import 'package:flutter/material.dart';

enum ScreenType { mobile, desktop }

extension BuildContextExtension on BuildContext {

  Size get size => MediaQuery.sizeOf(this);
  double get height => size.height;
  double get width => size.width;

  bool get tooSmall => width < 350 || height < 500;

  ScreenType get screenType =>
      width > 900 ? ScreenType.desktop : ScreenType.mobile;

  bool get isScreenDesktop => screenType == ScreenType.desktop;

  bool get isScreenMobile => screenType == ScreenType.mobile;
}
