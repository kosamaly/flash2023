import 'package:flutter/material.dart';

class EyeButton extends StatelessWidget {
  final bool isObscured;
  final VoidCallback onPressed;
  const EyeButton(
      {super.key, required this.isObscured, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsetsDirectional.only(end: 12),
      icon: isObscured
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      onPressed: onPressed,
    );
  }
}
