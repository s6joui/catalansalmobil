
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension CAMAnimationWidgetExtensions on Widget {

  Animate shimmerLoop() =>
    animate(onPlay: (controller) => controller.repeat()).shimmer(delay: 300.ms);
  
}
