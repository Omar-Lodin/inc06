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

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  // Drawing "state" — changing these + setState() triggers shouldRepaint
  //double mood = 0.8; // 0.0 sad → 1.0 happy
  int selectedFace = 0; // 0 classic, 1 sleepy, 2 surprised
  CustomPainter get selectedPainter {
    switch (selectedFace) {
      case 1:
        return SleepyPainter();
      case 2:
        return SurprisedPainter();
      default:
        return ClassicPainter();
    }
  }


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
                painter: selectedPainter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text('Classic'),
                  selected: selectedFace == 0,
                  onSelected: (_) {
                    setState(() => selectedFace = 0
                    );
                  },
                ),
                ChoiceChip(
                  label: const Text('Sleepy'),
                  selected: selectedFace == 1,
                  onSelected: (_) {
                    setState(() => selectedFace = 1);
                  },
                ),
                ChoiceChip(
                  label: const Text('Surprised'),
                  selected: selectedFace == 2,
                  onSelected: (_) {
                    setState(() => selectedFace = 2);
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


void drawFace(Canvas canvas, Offset center, double radius, Color color) {
  canvas.drawCircle(
    center,
    radius,
    Paint()..color = color,
  );

  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4,
  );
}

class ClassicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide * 0.40;

    drawFace(canvas, c, r, Colors.yellow.shade600);

    final eyePaint = Paint()..color = Colors.black87;

    canvas.drawCircle(
      Offset(c.dx - r * 0.35, c.dy - r * 0.18),
      r * 0.08,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(c.dx + r * 0.35, c.dy - r * 0.18),
      r * 0.08,
      eyePaint,
    );

    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(c.dx, c.dy + r * 0.15),
      width: r * 1.1,
      height: r * 0.8,
    );

    canvas.drawArc(
      mouthRect,
      0.15 * pi,
      0.70 * pi,
      false,
      mouthPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ClassicPainter oldDelegate) => false;
}


class SleepyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide * 0.40;

    drawFace(canvas, c, r, Colors.lightBlue.shade200);

    final stroke = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (final eyeX in [c.dx - r * 0.35, c.dx + r * 0.35]) {
      final eyeRect = Rect.fromCenter(
        center: Offset(eyeX, c.dy - r * 0.18),
        width: r * 0.30,
        height: r * 0.16,
      );

      canvas.drawArc(eyeRect, 0, pi, false, stroke);
    }

    final mouthRect = Rect.fromCenter(
      center: Offset(c.dx, c.dy + r * 0.30),
      width: r * 0.45,
      height: r * 0.15,
    );

    canvas.drawArc(mouthRect, 0, pi, false, stroke);
  }

  @override
  bool shouldRepaint(covariant SleepyPainter oldDelegate) => false;
}


class SurprisedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide * 0.40;

    drawFace(canvas, c, r, Colors.orange.shade300);

    final fill = Paint()..color = Colors.black87;

    canvas.drawCircle(
      Offset(c.dx - r * 0.35, c.dy - r * 0.18),
      r * 0.13,
      fill,
    );
    canvas.drawCircle(
      Offset(c.dx + r * 0.35, c.dy - r * 0.18),
      r * 0.13,
      fill,
    );

    canvas.drawCircle(
      Offset(c.dx, c.dy + r * 0.35),
      r * 0.20,
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant SurprisedPainter oldDelegate) => false;
}