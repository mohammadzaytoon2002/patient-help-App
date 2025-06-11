import 'dart:ui';

import 'package:flutter/material.dart';

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double curveHeight = 120;
    double curveDistance = 50;
    Path path = Path();
    path.lineTo(0, rect.height - curveHeight);
    path.quadraticBezierTo(
        rect.width / 2, rect.height, rect.width, rect.height - curveHeight);
    path.lineTo(rect.width, 0);
    path.close();
    return path;
  }
}
