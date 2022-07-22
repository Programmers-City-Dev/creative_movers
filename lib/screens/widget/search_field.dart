import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField(
      {Key? key, this.onChanged, this.controller, this.onSubmitted, this.hint, this.radius, this.fillcolor})
      : super(key: key);
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmitted;
  final String? hint;
  final TextEditingController? controller;
  final double? radius;
  final Color? fillcolor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        onSubmitted: onSubmitted,
        controller: controller,
        onChanged: onChanged,
        maxLines: 1,

        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.all(10),
          filled: true,
          fillColor: fillcolor ?? AppColors.lightGrey,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textColor,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular( radius==null ?30:radius!),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
