import 'package:flutter/material.dart';
import 'dart:math';


class CircularSlider extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final Size circleSize;
  final double circleWidth;

  const CircularSlider({super.key, 
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.circleSize,
    required this.circleWidth
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: circleSize, // Taille du widget
      painter: CircularSliderPainter(
        progress: progress,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
        circleWidth: circleWidth,
      ),
    );
  }
}

class CircularSliderPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double circleWidth;


  CircularSliderPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.circleWidth,

  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * pi,
      false,
      paint,
    );

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      (progress / 100) * 2 * pi,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

