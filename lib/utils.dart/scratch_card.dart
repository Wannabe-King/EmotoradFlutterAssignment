import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

enum ScratchAccuracy { low, medium, high }

class ScratchPoint {
  final Offset? position;
  final double size;

  ScratchPoint(this.position, this.size);
}

class ScratchPainter extends CustomPainter {
  ScratchPainter({
    required this.points,
    required this.color,
    required this.onDraw,
    required this.text,
    required this.textStyle,
    this.image,
    this.imageFit,
  });

  final List<ScratchPoint?> points;
  final Color color;
  final void Function(Size) onDraw;
  final ui.Image? image;
  final BoxFit? imageFit;
  final String text;
  final TextStyle textStyle;

  Paint _getMainPaint(double strokeWidth) {
    return Paint()
      ..strokeCap = StrokeCap.round
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..blendMode = BlendMode.clear
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    onDraw(size);
    canvas.saveLayer(null, Paint());

    // Draw base layer
    final areaRect = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.drawRect(areaRect, Paint()..color = color);

    // Draw instruction text
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);

    // Draw scratch paths
    var path = Path();
    ScratchPoint? previousPoint;
    for (final point in points) {
      if (point == null) {
        if (previousPoint != null)
          canvas.drawPath(path, _getMainPaint(previousPoint.size));
        path = Path();
      } else {
        if (path.getBounds().isEmpty) {
          path.moveTo(point.position!.dx, point.position!.dy);
        } else {
          path.lineTo(point.position!.dx, point.position!.dy);
        }
      }
      previousPoint = point;
    }
    if (previousPoint != null)
      canvas.drawPath(path, _getMainPaint(previousPoint.size));

    canvas.restore();
  }

  @override
  bool shouldRepaint(ScratchPainter oldDelegate) => true;
}

class Scratcher extends StatefulWidget {
  const Scratcher({
    super.key,
    required this.child,
    this.brushSize = 25,
    this.threshold = 50,
    this.accuracy = ScratchAccuracy.medium,
    this.color = Colors.grey,
    this.text = 'Scratch to reveal your reward!',
    this.textStyle = const TextStyle(fontSize: 18, color: Colors.white),
    this.onScratchComplete,
  });

  final Widget child;
  final double brushSize;
  final double threshold;
  final ScratchAccuracy accuracy;
  final Color color;
  final String text;
  final TextStyle textStyle;
  final VoidCallback? onScratchComplete;

  @override
  State<Scratcher> createState() => _ScratcherState();
}

class _ScratcherState extends State<Scratcher> {
  List<ScratchPoint?> points = [];
  Set<Offset> checkpoints = {};
  Set<Offset> checked = {};
  double progress = 0;
  bool thresholdReached = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => _addPoint(details.localPosition),
      onPanUpdate: (details) => _addPoint(details.localPosition),
      onPanEnd: (_) => points.add(null),
      child: CustomPaint(
        foregroundPainter: ScratchPainter(
          points: points,
          color: widget.color,
          text: widget.text,
          textStyle: widget.textStyle,
          onDraw: (size) => _updateCheckpoints(size),
        ),
        child: widget.child,
      ),
    );
  }

  void _addPoint(Offset position) {
    if (thresholdReached) return;

    final point = ScratchPoint(position, widget.brushSize);
    setState(() => points.add(point));
    _updateProgress(position);
  }

  void _updateProgress(Offset position) {
    final radius = widget.brushSize / 2;
    final affected =
        checkpoints.where((p) => _isInCircle(p, position, radius)).toSet();

    checkpoints.removeAll(affected);
    checked.addAll(affected);

    final newProgress = ((1 - (checkpoints.length / _totalCheckpoints)) * 100);
    if (newProgress - progress > 1 || newProgress >= 100) {
      progress = newProgress;
      if (progress >= widget.threshold) {
        thresholdReached = true;
        widget.onScratchComplete?.call();
      }
    }
  }

  bool _isInCircle(Offset center, Offset point, double radius) {
    return pow((center.dx - point.dx), 2) + pow((center.dy - point.dy), 2) <=
        pow(radius, 2);
  }

  double get _totalCheckpoints {
    const accuracyValues = {
      ScratchAccuracy.low: 10.0,
      ScratchAccuracy.medium: 30.0,
      ScratchAccuracy.high: 50.0
    };
    final accuracy = accuracyValues[widget.accuracy]!;
    return accuracy * accuracy;
  }

  void _updateCheckpoints(Size size) {
    if (checkpoints.isNotEmpty) return;

    final accuracy = sqrt(_totalCheckpoints);
    final xStep = size.width / accuracy;
    final yStep = size.height / accuracy;

    checkpoints = {
      for (var x = 0.0; x < size.width; x += xStep)
        for (var y = 0.0; y < size.height; y += yStep)
          Offset(x + xStep / 2, y + yStep / 2)
    };
  }
}
