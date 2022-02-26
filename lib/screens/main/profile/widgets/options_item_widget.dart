import 'package:flutter/material.dart';

class OptionsItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function()? onPressed;
  final bool showAlertIcon;
  final Color? subtitleColor;
  final bool? elevated;
  final Widget? trailing;

  const OptionsItemWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onPressed,
    this.showAlertIcon = false,
    this.subtitleColor,
    this.elevated = true,
    this.trailing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (elevated!)
              BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              )
          ]),
      child: ListTile(
        onTap: onPressed,
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(
              color: Color(0xFF3E3E3E),
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              color: subtitleColor ?? const Color(0xFFBDBDBD),
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showAlertIcon)
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.info, color: Colors.red, size: 19),
              ),
            if (onPressed != null)
              trailing == null
                  ? const Icon(Icons.edit_outlined,
                      color: Colors.black, size: 20)
                  : trailing!,
          ],
        ),
      ),
    );
  }
}
