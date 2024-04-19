import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  static const _textShadow = Shadow(offset: Offset(0, 1.0), blurRadius: 4.0,color: Color.fromARGB(70, 0, 0, 0));

  final String text;

  const Headline({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headlineLarge?.apply(fontWeightDelta: 4, shadows: [_textShadow]));
  }
}