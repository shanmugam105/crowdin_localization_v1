//
// ---------------- Progress Gauge Card ----------------
//
import 'dart:math' as math;

import 'package:flutter/material.dart';

class ProgressGaugeCard extends StatelessWidget {
  final bool showInfo;
  final double progress; // 0.0 – 1.0
  final double? weight;

  const ProgressGaugeCard({
    super.key,
    this.showInfo = false,
    required this.progress,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    var weight1 = weight?.toStringAsFixed(0) ?? progress.toStringAsFixed(2);
    return Column(
      children: [
        SizedBox(
          height: 180,
          width: double.infinity,
          child: CustomPaint(
            painter: SemiCircleGaugePainter(progress: progress),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 40),
                    child: Text(
                      '$weight1 kg',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 34),
                    child: Text(
                      'Current weight',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: Color(0x99000000),
                        fontFamily: 'NeueMontrealMono',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showInfo)
          Column(
            children: [
              Text(
                'You are loosing weight',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Keep it up your current pace',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
      ],
    );
  }
}

//
// ---------------- Semi-circle Painter ----------------
//
class SemiCircleGaugePainter extends CustomPainter {
  final double progress;
  SemiCircleGaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.9);
    final radius = size.width * 0.4;
    const totalTicks = 38;
    const tickLength = 28.0;
    const tickWidth = 3.0;

    const startAngle = math.pi; // left
    const sweepAngle = math.pi; // semi circle

    for (int i = 0; i < totalTicks; i++) {
      final angle = startAngle + (i / totalTicks) * sweepAngle;
      final isActive = i / totalTicks <= progress;

      final paint = Paint()
        ..color = isActive ? Colors.green : Colors.grey[300]!
        ..strokeWidth = tickWidth
        ..strokeCap = StrokeCap.round;

      final start = Offset(
        center.dx + math.cos(angle) * (radius - tickLength),
        center.dy + math.sin(angle) * (radius - tickLength),
      );
      final end = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
