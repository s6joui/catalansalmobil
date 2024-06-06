import 'package:flutter/material.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar(
      {super.key,
      required this.color,
      required this.name,
      required this.foregroundColor,
      this.textStyle = const TextStyle(
          letterSpacing: 1,
          fontSize: 30,
          height: -0.1,
          fontWeight: FontWeight.bold)});

  final Color color;
  final String name;
  final Color foregroundColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 70,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(1, 1),
                blurRadius: 3.0)
          ],
          border: Border.all(color: foregroundColor.withAlpha(90), width: 8),
          color: color),
      child: Center(
          child: Text(
        name.characters.first.toUpperCase(),
        textAlign: TextAlign.center,
        style: textStyle.copyWith(color: foregroundColor),
      )),
    );
  }
}
