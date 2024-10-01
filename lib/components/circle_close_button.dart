import 'package:flutter/material.dart';

class CircleCloseButton extends StatelessWidget {
  const CircleCloseButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton.filled(
        padding: EdgeInsets.zero,
        color: Colors.white,
        icon: const Icon(
          Icons.close_rounded,
          size: 16,
        ),
        style: IconButton.styleFrom(
          backgroundColor: Colors.redAccent,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
