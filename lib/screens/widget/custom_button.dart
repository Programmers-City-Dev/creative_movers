import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key, this.child, this.onTap, this.isEnabled = true, this.height, this.color})
      : super(key: key);
  final VoidCallback? onTap;
  final bool isEnabled;
  final Widget? child;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: color ?? AppColors.primaryColor,
              padding: const EdgeInsets.all(16)),
          onPressed: isEnabled ? onTap : null,
          child: Center(
            child: child,
          )),
    );
  }
}
