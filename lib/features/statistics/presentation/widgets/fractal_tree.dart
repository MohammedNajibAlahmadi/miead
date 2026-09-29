import 'dart:math' as math;
import 'package:flutter/material.dart';

class FractalTree extends StatelessWidget {
  final int focusMinutes;

  const FractalTree({super.key, required this.focusMinutes});

  @override
  Widget build(BuildContext context) {
    // 1 branching level per 25 minutes, max 8 levels.
    final depth = math.min(focusMinutes ~/ 25, 8);
    final isSeed = focusMinutes < 25;

    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, 250),
            painter: _TreePainter(depth: depth, isSeed: isSeed, color: Theme.of(context).primaryColor),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isSeed ? 'اغرس بذرتك.. (تبدأ بالنمو بعد 25 دقيقة تركيز)' : 'شجرة إنجازك (المستوى $depth)',
                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TreePainter extends CustomPainter {
  final int depth;
  final bool isSeed;
  final Color color;

  _TreePainter({required this.depth, required this.isSeed, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the ground
    final groundPaint = Paint()
      ..color = Colors.brown.shade300
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(Offset(size.width * 0.2, size.height - 20), Offset(size.width * 0.8, size.height - 20), groundPaint);

    if (isSeed) {
      // Draw a glowing seed
      final seedPaint = Paint()..color = color;
      canvas.drawCircle(Offset(size.width / 2, size.height - 25), 8, seedPaint);
      // Small sprout
      final sprout = Paint()..color = Colors.lightGreen..strokeWidth = 3..style = PaintingStyle.stroke;
      canvas.drawArc(Rect.fromLTWH(size.width / 2 - 10, size.height - 40, 20, 20), 0, -math.pi, false, sprout);
      return;
    }

    // Draw the Fractal Tree
    final paint = Paint()
      ..color = Colors.brown.shade700
      ..style = PaintingStyle.stroke;

    _drawBranch(canvas, Offset(size.width / 2, size.height - 20), -math.pi / 2, 60.0, depth, paint);
  }

  void _drawBranch(Canvas canvas, Offset start, double angle, double length, int currentDepth, Paint paint) {
    if (currentDepth == 0) return;

    final end = Offset(
      start.dx + length * math.cos(angle),
      start.dy + length * math.sin(angle),
    );

    paint.strokeWidth = currentDepth * 1.5;
    
    // If it's the last 2 levels of depth, make it green like leaves
    if (currentDepth <= 2) {
      paint.color = color;
    } else {
      paint.color = Colors.brown.shade700;
    }

    canvas.drawLine(start, end, paint);

    // Left branch
    _drawBranch(canvas, end, angle - (math.pi / 5), length * 0.7, currentDepth - 1, paint);
    // Right branch
    _drawBranch(canvas, end, angle + (math.pi / 5), length * 0.7, currentDepth - 1, paint);
  }

  @override
  bool shouldRepaint(covariant _TreePainter oldDelegate) {
    return oldDelegate.depth != depth || oldDelegate.isSeed != isSeed;
  }
}
