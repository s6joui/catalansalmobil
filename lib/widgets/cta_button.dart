import 'package:flutter/material.dart';

class CtaButton extends StatelessWidget {
  const CtaButton({
    super.key,
    required this.title, required this.color, this.onPressed,
  });

  final String title;
  final Color color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: Text(title, style: const TextStyle(fontSize: 16, letterSpacing: -0.5, fontWeight: FontWeight.w600),),
            ),
      ),
    );
  }
}