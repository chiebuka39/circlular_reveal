import 'package:flutter/material.dart';
import 'dart:math' as math;

/// An indicator showing the currently selected page of a PageController
/// Original source:https://gist.github.com/collinjackson/4fddbfa2830ea3ac033e34622f278824
class DotsIndicator extends AnimatedWidget {
  DotsIndicator(
      {@required this.controller,
        @required this.itemCount,
        this.color: Colors.white,
        this.size = 10,
        this.selectedSize = 20,
        this.spacing = 10,
        this.selectedColor = Colors.indigoAccent})
      : _colorTween = ColorTween(begin: color, end: selectedColor),
        _sizeTween = Tween<double>(begin: size, end: selectedSize),
        super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// The color of the dots in unselected state.
  ///
  /// Defaults to `Colors.black`.
  final Color color;

  /// The color of the dots in selected state.
  ///
  /// Defaults to `Colors.indigoAccent`.
  final Color selectedColor;

  /// The size of the dot in the unselected state
  /// Defaults to
  final double size;

  /// The size of dot in the selected state
  /// Defaults to
  final double selectedSize;

  /// The space between individual dots
  /// Defaults to 10
  final double spacing;

  final ColorTween _colorTween;

  final Tween<double> _sizeTween;

  Widget _buildDot(int index) {
    var t =
    math.max(0.0, 1.0 - ((controller.page ?? controller.initialPage) - index).abs());

    var _transformedSize = _sizeTween.transform(t);
    return Container(
      height: math.max(size, selectedSize),
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      child: Center(
        child: Material(
          color: _colorTween.transform(t),
          type: MaterialType.circle,
          child: SizedBox(
            width: _transformedSize,
            height: _transformedSize,
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}