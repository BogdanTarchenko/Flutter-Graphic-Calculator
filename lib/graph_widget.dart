import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'calculator_engine.dart';
import 'app_theme.dart';
import 'responsive_utils.dart';

class GraphWidget extends StatefulWidget {
  final String? function;
  final bool isDarkMode;
  
  const GraphWidget({
    super.key,
    this.function,
    this.isDarkMode = true,
  });

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  Offset _panOffset = Offset.zero;
  Offset? _lastPanPosition;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? _previousFunction;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(GraphWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.function != widget.function) {
      _previousFunction = oldWidget.function;
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _resetView() {
    setState(() {
      _scale = 1.0;
      _panOffset = Offset.zero;
    });
  }

  void _zoomIn() {
    setState(() {
      _scale = (_scale * 1.2).clamp(0.5, 5.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _scale = (_scale / 1.2).clamp(0.5, 5.0);
    });
  }

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
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: CustomPaint(
        painter: GraphPainter(
          function: widget.function,
          scale: _scale,
          panOffset: _panOffset,
          animationProgress: _fadeAnimation.value,
          isDarkMode: widget.isDarkMode,
        ),
                  child: Container(),
                ),
              );
            },
          ),
          Positioned(
            right: ResponsiveUtils.getAdaptivePadding(context, small: 8, medium: 12, large: 16),
            top: ResponsiveUtils.getAdaptivePadding(context, small: 8, medium: 12, large: 16),
            child: Column(
              children: [
                _ControlButton(
                  icon: Icons.add,
                  onPressed: _zoomIn,
                  isDarkMode: widget.isDarkMode,
                ),
                SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context, small: 4, medium: 6, large: 8)),
                _ControlButton(
                  icon: Icons.remove,
                  onPressed: _zoomOut,
                  isDarkMode: widget.isDarkMode,
                ),
                SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context, small: 4, medium: 6, large: 8)),
                _ControlButton(
                  icon: Icons.center_focus_strong,
                  onPressed: _resetView,
                  isDarkMode: widget.isDarkMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDarkMode;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveUtils.getAdaptiveFontSize(context, small: 32, medium: 40, large: 48);
    final iconSize = ResponsiveUtils.getAdaptiveFontSize(context, small: 16, medium: 20, large: 24);
    final borderRadius = ResponsiveUtils.getBorderRadius(context);
    
    return Material(
      color: Colors.deepPurple.withOpacity(0.8),
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: iconSize),
        ),
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final String? function;
  final double scale;
  final Offset panOffset;
  final double animationProgress;
  final bool isDarkMode;

  GraphPainter({
    this.function,
    required this.scale,
    required this.panOffset,
    this.animationProgress = 1.0,
    this.isDarkMode = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2 + panOffset.dx;
    final centerY = size.height / 2 + panOffset.dy;
    final pixelsPerUnit = 50.0 * scale;

    final axisPaint = Paint()
      ..color = isDarkMode ? Colors.grey[600]! : Colors.grey[400]!
      ..strokeWidth = 1.5;

    final gridPaint = Paint()
      ..color = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!
      ..strokeWidth = 0.5;

    final graphPaint = Paint()
      ..color = Colors.deepPurpleAccent.withOpacity(animationProgress)
      ..strokeWidth = 2 * animationProgress
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

    final textSize = size.width < 600 ? 10.0 : (size.width < 1200 ? 12.0 : 14.0);
    
    final textStyle = TextStyle(
      color: isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
      fontSize: textSize,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = -5; i <= 5; i++) {
      if (i == 0) continue;
      
      final x = centerX + i * pixelsPerUnit;
      final y = centerY - i * pixelsPerUnit;
      
      if (x >= 0 && x <= size.width && i != 0) {
        textPainter.text = TextSpan(text: i.toString(), style: textStyle);
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, centerY + 5),
        );
      }
      
      if (y >= 0 && y <= size.height && i != 0) {
        textPainter.text = TextSpan(text: (-i).toString(), style: textStyle);
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(centerX + 5, y - textPainter.height / 2),
        );
      }
    }

    textPainter.text = TextSpan(
      text: '0',
      style: TextStyle(
        color: isDarkMode ? Colors.grey : Colors.grey[700]!,
        fontSize: 12,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(centerX + 5, centerY + 5),
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
        oldDelegate.panOffset != panOffset ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
