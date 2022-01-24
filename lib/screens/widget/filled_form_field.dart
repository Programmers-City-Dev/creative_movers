import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FilledFormField extends StatefulWidget {
  const FilledFormField(
      {Key? key,
      // required this.icon,
      this.obscure = false,
      this.controller,
      this.validator,
      required this.hint,
      this.toggle_icon = const SizedBox(), this.maxlines = 1})
      : super(key: key);

  // final IconData icon;
  final Widget toggle_icon;
  final bool obscure;
  final String hint;
  final int maxlines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  _FilledFormFieldState createState() => _FilledFormFieldState();
}

class _FilledFormFieldState extends State<FilledFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxlines,
      obscureText:  widget.obscure,
      controller:  widget.controller,
      cursorColor: AppColors.primaryColor,
      validator:  widget.validator,
      decoration: InputDecoration(
        filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(17),

          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 13),
          // label: Text(
          //   widget.hint,
          //   style: TextStyle(color: AppColors.textColor),
          // ),

          // hintText: hint,

          focusColor: AppColors.primaryColor,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          alignLabelWithHint: false,
          // prefixIcon: Icon(
          //   widget.icon,
          //   color: AppColors.textColor,
          // ),
          suffixIcon:  widget.toggle_icon),
    );
  }
}
