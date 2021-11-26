import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final double size;
  final Color active_color;
  final bool isActive;
  final Color inActiveColor;

  const DotIndicator({Key? key, this.size = 8,  this.active_color=Colors.blue, required this.isActive, this.inActiveColor = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: isActive ? active_color : inActiveColor,
          borderRadius: BorderRadius.circular(size * 0.50)),
      duration: Duration(milliseconds: 500),
    );
  }
}
