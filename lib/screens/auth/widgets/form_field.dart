import 'package:creative_movers/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.icon,
      this.obscure = false,
      this.controller,
      this.validator, required this.hint})
      : super(key: key);
  final IconData icon;
  final bool obscure;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      controller: controller,
      validator:validator,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16),
        focusedBorder:const OutlineInputBorder(
            borderSide:  BorderSide(color:AppColors.primaryColor )),
          // label: Text(),
        labelText: hint,

        border: const OutlineInputBorder(borderSide: BorderSide()),
          alignLabelWithHint: false,
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          )),
    );
  }
}
