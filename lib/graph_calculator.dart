import 'package:flutter/material.dart';
import 'calculator_engine.dart';
import 'app_theme.dart';
import 'graph_widget.dart';
import 'calculator_keyboard.dart';
import 'responsive_utils.dart';

class GraphCalculator extends StatefulWidget {
  final bool isDarkMode;

  const GraphCalculator({super.key, required this.isDarkMode});

  @override
  State<GraphCalculator> createState() => _GraphCalculatorState();
}

class _GraphCalculatorState extends State<GraphCalculator> {
  String _display = '0';
  String _expression = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _expression = '';
      } else if (value == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else if (value == '=') {
        _expression = _display;
      } else {
        if (_display == '0' && value != '.' && value != 'x') {
          _display = value;
        } else if (_display == 'Ошибка') {
          _display = value;
        } else {
          _display += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final displayPadding = ResponsiveUtils.getDisplayPadding(context);
    final keyboardPadding = ResponsiveUtils.getKeyboardPadding(context);
    final displayFontSize = ResponsiveUtils.getDisplayFontSize(context);
    final expressionFontSize = ResponsiveUtils.getExpressionFontSize(context);
    final displayFlex = ResponsiveUtils.getDisplayFlex(context);
    final graphFlex = ResponsiveUtils.getGraphFlex(context);
    final keyboardFlex = ResponsiveUtils.getKeyboardFlex(context);
    
    return Column(
      children: [
        Expanded(
          flex: displayFlex,
          child: Container(
            width: double.infinity,
            padding: displayPadding,
            color: AppTheme.getDisplayBackgroundColor(isDark),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression.isEmpty ? '' : _expression,
                  style: TextStyle(
                    fontSize: expressionFontSize,
                    color: AppTheme.getSecondaryTextColor(isDark),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context, small: 4, medium: 6, large: 8)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _display,
                    style: TextStyle(
                      fontSize: displayFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getTextColor(isDark),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: graphFlex,
          child: Container(
            color: AppTheme.getGraphBackgroundColor(isDark),
            child: GraphWidget(
              function: _expression.contains('x') ? _expression : null,
              isDarkMode: isDark,
            ),
          ),
        ),
        Expanded(
          flex: keyboardFlex,
          child: Container(
            color: AppTheme.getKeyboardBackgroundColor(isDark),
            padding: keyboardPadding,
            child: GraphKeyboard(
              onButtonPressed: _onButtonPressed,
              isDarkMode: isDark,
            ),
          ),
        ),
      ],
    );
  }
}

class GraphKeyboard extends StatelessWidget {
  final Function(String) onButtonPressed;
  final bool isDarkMode;

  const GraphKeyboard({
    super.key,
    required this.onButtonPressed,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.getKeyboardSpacing(context);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        int columns = 4;
        if (maxWidth > 800) columns = 5;
        if (maxWidth > 1200) columns = 6;
        
        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
      children: [
        CalculatorButton(
          label: 'C',
          color: Colors.red,
          onPressed: () => onButtonPressed('C'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '⌫',
          color: Colors.orange,
          onPressed: () => onButtonPressed('⌫'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '(',
          color: Colors.blue,
          onPressed: () => onButtonPressed('('),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: ')',
          color: Colors.blue,
          onPressed: () => onButtonPressed(')'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '7',
          onPressed: () => onButtonPressed('7'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '8',
          onPressed: () => onButtonPressed('8'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '9',
          onPressed: () => onButtonPressed('9'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '÷',
          color: Colors.purple,
          onPressed: () => onButtonPressed('/'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '4',
          onPressed: () => onButtonPressed('4'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '5',
          onPressed: () => onButtonPressed('5'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '6',
          onPressed: () => onButtonPressed('6'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '×',
          color: Colors.purple,
          onPressed: () => onButtonPressed('*'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '1',
          onPressed: () => onButtonPressed('1'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '2',
          onPressed: () => onButtonPressed('2'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '3',
          onPressed: () => onButtonPressed('3'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '-',
          color: Colors.purple,
          onPressed: () => onButtonPressed('-'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '0',
          onPressed: () => onButtonPressed('0'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '.',
          onPressed: () => onButtonPressed('.'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: 'x',
          color: Colors.teal,
          onPressed: () => onButtonPressed('x'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '+',
          color: Colors.purple,
          onPressed: () => onButtonPressed('+'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: 'sin',
          color: Colors.indigo,
          onPressed: () => onButtonPressed('sin('),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: 'cos',
          color: Colors.indigo,
          onPressed: () => onButtonPressed('cos('),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '^',
          color: Colors.purple,
          onPressed: () => onButtonPressed('^'),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '=',
          color: Colors.green,
          onPressed: () => onButtonPressed('='),
          isDarkMode: isDarkMode,
        ),
          ],
        );
      },
    );
  }
}
