import 'package:flutter/material.dart';

class CustomShapeBorder extends ShapeBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final double curveHeight = 50.0;
    path.moveTo(0, rect.bottom - curveHeight);
    path.quadraticBezierTo(rect.width / 2, rect.bottom + curveHeight,
        rect.width, rect.bottom - curveHeight);
    path.lineTo(rect.width, rect.top);
    path.lineTo(0, rect.top);
    path.close();
    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) => CustomShapeBorder();

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // No custom painting needed, but you can add custom painting code here if required.
  }
}
