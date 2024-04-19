import 'package:catalansalmon_flutter/widgets/globe_logo.dart';
import 'package:catalansalmon_flutter/widgets/headline.dart';
import 'package:flutter/material.dart';

class CAMLogo extends StatelessWidget {
  const CAMLogo({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Headline(text: 'Catalans al món '),
        GlobeLogo()
      ]
    );
  }
}