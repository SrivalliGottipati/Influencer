import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscure;
  final int? maxLines;
  final String? Function(String?)? validator;
  final bool readOnly;
  final AutovalidateMode autovalidateMode;
  const AppInput({
    super.key, 
    required this.controller, 
    required this.label, 
    this.hintText,
    this.prefixIcon,
    this.keyboardType, 
    this.obscure = false, 
    this.maxLines, 
    this.validator, 
    this.readOnly = false, 
    this.autovalidateMode = AutovalidateMode.onUserInteraction
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      readOnly: readOnly,
      autovalidateMode: autovalidateMode,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
    );
  }
}
