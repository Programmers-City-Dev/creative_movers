import 'package:flutter/material.dart';

import '../app_colors.dart';

class AppStyles {
  static InputDecoration labeledFieldDecoration({
    String? hinText,
    Widget? prefixIcon,
    String label = '',
    Widget? suffixIcon,
    String? hintText,
  }) =>
      InputDecoration(
        contentPadding: const EdgeInsets.all(17),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.textColor)),
        label: Text(
          label,
          style: const TextStyle(color: AppColors.textColor),
        ),

        // hintText: hint,

        focusColor: AppColors.primaryColor,
        border: const OutlineInputBorder(borderSide: BorderSide()),
        alignLabelWithHint: true,
        prefixIcon: prefixIcon,
        hintText: hinText,
        suffixIcon: suffixIcon,
      );
}
