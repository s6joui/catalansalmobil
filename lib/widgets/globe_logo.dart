import 'dart:async';

import 'package:flutter/material.dart';

class GlobeLogo extends StatefulWidget {
  const GlobeLogo({super.key});

  @override
  State<GlobeLogo> createState() => _GlobeLogoState();
}

class _GlobeLogoState extends State<GlobeLogo> {

  final emojiStates = ['🌍','🌏','🌎'];
  static const _textShadow = Shadow(offset: Offset(0, 1.0), blurRadius: 8.0,color: Color.fromARGB(70, 0, 0, 0));

  var _currentEmojiIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        if (_currentEmojiIndex == 2) {
          _currentEmojiIndex = 0;
        } else {
          _currentEmojiIndex++;
        }
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text(
          emojiStates[_currentEmojiIndex],
          style: Theme.of(context).textTheme.headlineLarge?.apply(shadows: [_textShadow])
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}