import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.child,
      this.onTap,
      this.isEnabled = true,
      this.height,
      this.color,
      this.radius,
      this.isBusy})
      : super(key: key);
  final VoidCallback? onTap;
  final bool isEnabled;
  final Widget child;
  final double? height;
  final Color? color;
  final double? radius;
  final bool? isBusy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? 0)),
              elevation: 0,
              backgroundColor: color ?? AppColors.primaryColor,
              padding: const EdgeInsets.all(16)),
          onPressed: isEnabled ? onTap : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isBusy ?? false)
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              child,
            ],
          )),
    );
  }
}
