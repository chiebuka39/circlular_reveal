import 'package:circlular_reveal/Clipper/circular_reveal_clipper.dart';
import 'package:flutter/material.dart';

/// This class reveals the next page in the circular form.

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;

  //Constructor
  PageReveal({this.revealPercent, this.child});

  @override
  Widget build(BuildContext context) {
    //ClipOval cuts the page to circular shape.
    return new ClipOval(
      clipper: new CircularRevealClipper(revealPercent: revealPercent),
      child: child,
    );
  }
}
