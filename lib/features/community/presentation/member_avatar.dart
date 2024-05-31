import 'package:flutter/material.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar(
      {super.key,
      required this.color,
      required this.name,
      this.foregroundColor = Colors.white});

  final Color color;
  final String name;
  final Color foregroundColor;

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
          border: Border.all(color: Colors.white.withAlpha(90), width: 8),
          color: color),
      child: Center(
          child: Text(
        name.characters.first,
        textAlign: TextAlign.center,
        style: TextStyle(
            letterSpacing: -1.0,
            fontSize: 30,
            color: foregroundColor,
            fontWeight: FontWeight.bold),
      )),
    );
  }
}
