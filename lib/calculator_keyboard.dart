import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'responsive_utils.dart';

class CalculatorButton extends StatefulWidget {
  final String label;
  final Color? color;
  final VoidCallback onPressed;
  final bool isDarkMode;

  const CalculatorButton({
    super.key,
    required this.label,
    this.color,
    required this.onPressed,
    required this.isDarkMode,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppTheme.getButtonColor(widget.isDarkMode, null);
    final fontSize = ResponsiveUtils.getButtonFontSize(context);
    final borderRadius = ResponsiveUtils.getBorderRadius(context);
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: buttonColor.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: widget.color != null ? Colors.white : AppTheme.getTextColor(widget.isDarkMode),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
