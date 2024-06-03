import 'package:catalansalmon_flutter/widgets/color_dot.dart';
import 'package:flutter/material.dart';

class CommunityButton extends StatelessWidget {
  const CommunityButton(
      {super.key, required this.title, required this.color, this.onPressed});

  final String title;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 54,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ColorDot(color: color),
              const SizedBox(width: 8),
              Text(title),
              const Spacer(),
              Icon(Icons.chevron_right_outlined,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(0.4))
            ],
          ),
        ),
      ),
    );
  }
}
