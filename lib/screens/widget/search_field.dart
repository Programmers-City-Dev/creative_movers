import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField(
      {Key? key, this.onChanged, this.controller, this.onSubmitted, this.hint, this.radius})
      : super(key: key);
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmitted;
  final String? hint;
  final TextEditingController? controller;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        onSubmitted: onSubmitted,
        controller: controller,
        onChanged: onChanged,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.all(7),
          filled: true,
          fillColor: AppColors.lightGrey,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textColor,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular( radius==null ?30:0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
