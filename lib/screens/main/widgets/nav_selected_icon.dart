import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavSelectedIcon extends StatefulWidget {
  const NavSelectedIcon({Key? key, required this.label, required this.strIcon})
      : super(key: key);
  final String label;
  final String strIcon;

  @override
  _NavSelectedIconState createState() => _NavSelectedIconState();
}

class _NavSelectedIconState extends State<NavSelectedIcon> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 2000),
      opacity: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        // margin: const EdgeInsets.symmetric(horizontal:2 ),
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(5)),
        // alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              widget.strIcon,
              width: 16,
              color: AppColors.smokeWhite,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.label,
              style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.smokeWhite,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
