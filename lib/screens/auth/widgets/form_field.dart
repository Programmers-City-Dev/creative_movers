import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.icon,
      this.obscure = false,
      this.controller,
      this.validator,
      required this.hint,
      this.toggle_icon = const SizedBox(),
      this.focusNode,
      this.inputAction,
      this.onFieldSubmitted})
      : super(key: key);
  final IconData icon;
  final Widget toggle_icon;
  final bool obscure;
  final String hint;
  final FocusNode? focusNode;
  final TextInputAction? inputAction;
  final Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode ?? FocusNode(),
      textInputAction: inputAction ?? TextInputAction.none,
      cursorColor: AppColors.primaryColor,
      validator: validator,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(17),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide()),
          label: Text(
            hint,
            style: const TextStyle(color: AppColors.textColor),
          ),

          // hintText: hint,

          focusColor: AppColors.primaryColor,
          border: const OutlineInputBorder(borderSide: BorderSide()),
          alignLabelWithHint: false,
          prefixIcon: Icon(
            icon,
            color: AppColors.textColor,
          ),
          suffixIcon: toggle_icon),
    );
  }
}
