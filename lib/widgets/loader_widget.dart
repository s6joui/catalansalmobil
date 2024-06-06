import 'package:catalansalmon_flutter/widgets/globe_logo.dart';
import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const GlobeLogo(),
        const SizedBox(height: 16),
        Text(
          'catalansalmon.com',
          style: Theme.of(context).textTheme.titleLarge,
        )
      ],
    );
  }
}
