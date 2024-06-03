import 'package:flutter/material.dart';

class EncircledIcon extends StatelessWidget {
  const EncircledIcon({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              width: 3,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        child: Icon(
          icon,
          size: 40,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ));
  }
}
