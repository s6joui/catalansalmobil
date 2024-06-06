import 'package:flutter/material.dart';

class CtaButton extends StatelessWidget {
  const CtaButton({
    super.key,
    required this.title,
    required this.color,
    required this.foregroundColor,
    this.icon,
    this.width,
    this.onPressed,
  });

  final String title;
  final Color color;
  final Color foregroundColor;
  final IconData? icon;
  final double? width;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: foregroundColor,
                  fontSize: 16,
                  letterSpacing: -0.5,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            if (icon != null) const SizedBox(width: 8),
            if (icon != null) Icon(icon!, color: foregroundColor),
          ],
        ),
      ),
    );
  }
}
