import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FilledFormField extends StatefulWidget {
   FilledFormField(
      {Key? key,
      // required this.icon,
      this.obscure = false,
      this.controller,
      this.validator,
      required this.hint,
      this.toggle_icon = const SizedBox(), this.maxlines = 1, this.prefix,this.keyboardType, this.labeled = false})
      : super(key: key);

  // final IconData icon;
  final Widget toggle_icon;
   TextInputType? keyboardType = TextInputType.text;
   Widget? prefix = const SizedBox.shrink();
  final bool obscure;
  final String hint;
  final int maxlines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool labeled;


   @override
  _FilledFormFieldState createState() => _FilledFormFieldState();
}

class _FilledFormFieldState extends State<FilledFormField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType ,
      maxLines: widget.maxlines,
      obscureText:  widget.obscure,
      controller:  widget.controller,
      cursorColor: AppColors.primaryColor,
      autovalidateMode: AutovalidateMode.disabled,
      validator:  widget.validator,
      decoration: InputDecoration(

        filled: true,
          prefix: widget.prefix,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.all(17),

          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: widget.hint,
          hintStyle: const TextStyle(fontSize: 13),
          label: widget.labeled ? Text(
            widget.hint,
            style: const TextStyle(color: AppColors.textColor),
          ):const SizedBox.shrink(),

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
