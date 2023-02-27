import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CmPasswordField extends StatefulWidget {
  const CmPasswordField(
      {Key? key,
      required this.icon,
      this.obscure = true,
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
  final bool? obscure;
  final String hint;
  final FocusNode? focusNode;
  final TextInputAction? inputAction;
  final Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<CmPasswordField> createState() => _CmPasswordFieldState();
}

class _CmPasswordFieldState extends State<CmPasswordField> {
  late bool obscureText;

  @override
  initState() {
    super.initState();
    obscureText = widget.obscure ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: widget.controller,
      onFieldSubmitted: widget.onFieldSubmitted,
      focusNode: widget.focusNode ?? FocusNode(),
      textInputAction: widget.inputAction ?? TextInputAction.none,
      cursorColor: AppColors.primaryColor,
      validator: widget.validator,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(17),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide()),
          label: Text(
            widget.hint,
            style: const TextStyle(color: AppColors.textColor),
          ),

          // hintText: hint,

          focusColor: AppColors.primaryColor,
          border: const OutlineInputBorder(borderSide: BorderSide()),
          alignLabelWithHint: false,
          prefixIcon: Icon(
            widget.icon,
            color: AppColors.textColor,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            icon: obscureText
                ? const Icon(
                    Icons.visibility_off_outlined,
                    color: AppColors.textColor,
                  )
                : const Icon(
                    Icons.visibility_outlined,
                    color: AppColors.textColor,
                  ),
          )),
    );
  }
}
