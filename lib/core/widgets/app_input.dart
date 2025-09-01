import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool obscure;
  final int? maxLines;
  const AppInput({super.key, required this.controller, required this.label, this.keyboardType, this.obscure = false, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextField(controller: controller, obscureText: obscure, maxLines: maxLines ?? 1, keyboardType: keyboardType, decoration: InputDecoration(labelText: label));
  }
}
