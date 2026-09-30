// In-Class Activity 06 — Drawing with Flutter
// Student: Omar Lodin
// Date: September 30, 2026

import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() => runApp(const SmileyApp());

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

enum EyeStyle { round, closed }
enum MouthStyle { classic, soft, open }

class FaceConfig {
  const FaceConfig({
    required this.name,
    required this.eyeStyle,
    required this.eyeSize,
    required this.mouthStyle,
  });

  final String name;
  final EyeStyle eyeStyle;
  final double eyeSize;
  final MouthStyle mouthStyle;
}

const faceDesigns = [
  FaceConfig(
    name: 'Classic',
    eyeStyle: EyeStyle.round,
    eyeSize: 0.08,
    mouthStyle: MouthStyle.classic,
  ),
  FaceConfig(
    name: 'Sleepy',
    eyeStyle: EyeStyle.closed,
    eyeSize: 0.08,
    mouthStyle: MouthStyle.soft,
  ),
  FaceConfig(
    name: 'Surprised',
    eyeStyle: EyeStyle.round,
    eyeSize: 0.13,
    mouthStyle: MouthStyle.open,
  ),
];

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  double mood = 0.8;
  int selectedFace = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter Smiley Lab')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(300, 300),
                painter: FacePainter(
                  config: faceDesigns[selectedFace],
                  mood: mood,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (int i = 0; i < faceDesigns.length; i++)
                      ChoiceChip(
                        label: Text(faceDesigns[i].name),
                        selected: selectedFace == i,
                        onSelected: (_) {
                          setState(() => selectedFace = i);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Mood: ${mood.toStringAsFixed(2)}'),
                Slider(
                  value: mood,
                  min: 0,
                  max: 1,
                  onChanged: (double value) {
                    setState(() => mood = value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  FacePainter({
    required this.config,
    required this.mood,
  });

  final FaceConfig config;
  final double mood;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide * 0.40;

    final Color faceColor;
    if (mood < 0.35) {
      faceColor = Colors.lightBlue.shade200;
    } else if (mood <= 0.7) {
      faceColor = Colors.yellow.shade600;
    } else {
      faceColor = Colors.orange.shade400;
    }

    final fill = Paint()..color = Colors.black87;

    final stroke = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(c, r, Paint()..color = faceColor);
    canvas.drawCircle(c, r, stroke);

    // Eyes
    final eyeY = c.dy - r * 0.18;
    final eyeDx = r * 0.35;

    for (final eyeX in [c.dx - eyeDx, c.dx + eyeDx]) {
      if (config.eyeStyle == EyeStyle.round) {
        canvas.drawCircle(
          Offset(eyeX, eyeY),
          r * config.eyeSize,
          fill,
        );
      } else {
        final eyeRect = Rect.fromCenter(
          center: Offset(eyeX, eyeY),
          width: r * 0.30,
          height: r * config.eyeSize * 2,
        );

        canvas.drawArc(eyeRect, 0, pi, false, stroke);
      }
    }

    // Mouth
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    switch (config.mouthStyle) {
      case MouthStyle.classic:
        if (mood < 0.35) {
          // Frown
          final sadness = (0.35 - mood) / 0.35;
          final mouthRect = Rect.fromCenter(
            center: Offset(c.dx, c.dy + r * 0.45),
            width: r,
            height: r * (0.25 + sadness * 0.35),
          );

          canvas.drawArc(
            mouthRect,
            1.15 * pi,
            0.70 * pi,
            false,
            mouthPaint,
          );
        } else if (mood <= 0.7) {
          final softness = (mood - 0.35) / 0.35;
          final mouthY = c.dy + r * 0.35;

          final path = Path()
            ..moveTo(c.dx - r * 0.4, mouthY)
            ..quadraticBezierTo(
              c.dx,
              mouthY + r * 0.3 * softness,
              c.dx + r * 0.4,
              mouthY,
            );

          canvas.drawPath(path, mouthPaint);
        } else {
          final happiness = (mood - 0.7) / 0.3;
          final mouthRect = Rect.fromCenter(
            center: Offset(c.dx, c.dy + r * 0.15),
            width: r * 1.15,
            height: r * (0.65 + happiness * 0.25),
          );

          canvas.drawArc(
            mouthRect,
            0.10 * pi,
            0.80 * pi,
            false,
            mouthPaint,
          );
        }
        break;

      case MouthStyle.soft:
        final mouthY = c.dy + r * 0.35;
        final path = Path()
          ..moveTo(c.dx - r * 0.23, mouthY)
          ..quadraticBezierTo(
            c.dx,
            mouthY + r * 0.18 * (mood * 2 - 1),
            c.dx + r * 0.23,
            mouthY,
          );

        canvas.drawPath(path, mouthPaint);
        break;

      case MouthStyle.open:
        // Surprised: open mouth grows with mood.
        final mouthRect = Rect.fromCenter(
          center: Offset(c.dx, c.dy + r * 0.35),
          width: r * (0.25 + mood * 0.15),
          height: r * (0.30 + mood * 0.20),
        );

        canvas.drawOval(mouthRect, fill);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) {
    final old = oldDelegate.config;

    return oldDelegate.mood != mood ||
        old.eyeStyle != config.eyeStyle ||
        old.eyeSize != config.eyeSize ||
        old.mouthStyle != config.mouthStyle;
  }
}