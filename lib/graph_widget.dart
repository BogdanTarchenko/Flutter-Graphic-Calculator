import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'calculator_engine.dart';

class GraphWidget extends StatefulWidget {
  final String? function;
  
  const GraphWidget({
    super.key,
    this.function,
  });

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  double _scale = 1.0;
  Offset _panOffset = Offset.zero;
  Offset? _lastPanPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _lastPanPosition = details.localFocalPoint;
      },
      onScaleUpdate: (details) {
        setState(() {
          if (details.scale != 1.0) {
            _scale = (_scale * details.scale).clamp(0.5, 5.0);
          }
          if (details.pointerCount == 1 && _lastPanPosition != null) {
            _panOffset += details.localFocalPoint - _lastPanPosition!;
          }
          _lastPanPosition = details.localFocalPoint;
        });
      },
      onScaleEnd: (details) {
        _lastPanPosition = null;
      },
      child: CustomPaint(
        painter: GraphPainter(
          function: widget.function,
          scale: _scale,
          panOffset: _panOffset,
        ),
        child: Container(),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final String? function;
  final double scale;
  final Offset panOffset;

  GraphPainter({
    this.function,
    required this.scale,
    required this.panOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2 + panOffset.dx;
    final centerY = size.height / 2 + panOffset.dy;
    final pixelsPerUnit = 50.0 * scale;

    final axisPaint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 2;

    final gridPaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 1;

    final graphPaint = Paint()
      ..color = Colors.deepPurpleAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int i = -20; i <= 20; i++) {
      final x = centerX + i * pixelsPerUnit;
      final y = centerY - i * pixelsPerUnit;
      
      if (x >= 0 && x <= size.width) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          gridPaint,
        );
      }
      
      if (y >= 0 && y <= size.height) {
        canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          gridPaint,
        );
      }
    }

    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      axisPaint,
    );

    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      axisPaint,
    );

    if (function != null && function!.isNotEmpty && function!.contains('x')) {
      final path = Path();
      bool isFirstPoint = true;
      
      for (double x = -size.width / pixelsPerUnit; x <= size.width / pixelsPerUnit; x += 0.1) {
        final y = _evaluateFunction(x);
        
        if (y.isFinite && !y.isNaN) {
          final screenX = centerX + x * pixelsPerUnit;
          final screenY = centerY - y * pixelsPerUnit;
          
          if (screenX >= 0 && screenX <= size.width &&
              screenY >= 0 && screenY <= size.height) {
            if (isFirstPoint) {
              path.moveTo(screenX, screenY);
              isFirstPoint = false;
            } else {
              path.lineTo(screenX, screenY);
            }
          } else {
            isFirstPoint = true;
          }
        } else {
          isFirstPoint = true;
        }
      }
      
      canvas.drawPath(path, graphPaint);
    }
  }

  double _evaluateFunction(double x) {
    if (function == null || function!.isEmpty) return 0;
    
    final result = CalculatorEngine.evaluate(function!, xValue: x);
    return result ?? 0;
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) {
    return oldDelegate.function != function ||
        oldDelegate.scale != scale ||
        oldDelegate.panOffset != panOffset;
  }
}
