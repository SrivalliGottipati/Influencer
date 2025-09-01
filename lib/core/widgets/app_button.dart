import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  const AppButton({super.key, required this.label, this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(onPressed: loading ? null : onPressed, child: loading ? const CircularProgressIndicator.adaptive() : Text(label)),
    );
  }
}
