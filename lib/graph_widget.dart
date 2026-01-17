import 'package:flutter/material.dart';
import 'dart:math' as math;

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
    
    try {
      String expr = function!.replaceAll('x', x.toString());
      expr = expr.replaceAll('sin(', 'math.sin(');
      expr = expr.replaceAll('cos(', 'math.cos(');
      expr = expr.replaceAll('tan(', 'math.tan(');
      expr = expr.replaceAll('^', 'math.pow(');
      
      return _simpleEval(expr);
    } catch (e) {
      return 0;
    }
  }

  double _simpleEval(String expr) {
    try {
      expr = expr.replaceAll(' ', '');
      
      if (expr.contains('+')) {
        final parts = expr.split('+');
        return parts.map((p) => _simpleEval(p)).reduce((a, b) => a + b);
      }
      if (expr.contains('-') && !expr.startsWith('-')) {
        final parts = expr.split('-');
        return _simpleEval(parts[0]) - _simpleEval(parts[1]);
      }
      if (expr.contains('*')) {
        final parts = expr.split('*');
        return parts.map((p) => _simpleEval(p)).reduce((a, b) => a * b);
      }
      if (expr.contains('/')) {
        final parts = expr.split('/');
        return _simpleEval(parts[0]) / _simpleEval(parts[1]);
      }
      
      if (expr.startsWith('math.sin(')) {
        final arg = expr.substring(9, expr.length - 1);
        return math.sin(_simpleEval(arg));
      }
      if (expr.startsWith('math.cos(')) {
        final arg = expr.substring(9, expr.length - 1);
        return math.cos(_simpleEval(arg));
      }
      if (expr.startsWith('math.tan(')) {
        final arg = expr.substring(9, expr.length - 1);
        return math.tan(_simpleEval(arg));
      }
      if (expr.startsWith('math.pow(')) {
        final args = expr.substring(9, expr.length - 1);
        final parts = args.split(',');
        return math.pow(_simpleEval(parts[0]), _simpleEval(parts[1])).toDouble();
      }
      
      return double.parse(expr);
    } catch (e) {
      return 0;
    }
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) {
    return oldDelegate.function != function ||
        oldDelegate.scale != scale ||
        oldDelegate.panOffset != panOffset;
  }
}
