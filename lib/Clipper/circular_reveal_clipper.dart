import 'dart:math';

import 'package:flutter/material.dart';

/// Custom clipper for circular page reveal.

class CircularRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  CircularRevealClipper({this.revealPercent});

  @override
  Rect getClip(Size size) {
    // center of rectangle
    final center = new Offset(size.height / 1.9, size.width * 1.15);

    // Calculate distance from center to the top left corner to make sure we fill the screen via simple trigonometry.
    double theta = atan(center.dy / center.dx);
    final distanceToCorner = center.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;

    return new Rect.fromLTWH(
        center.dx - radius, center.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
