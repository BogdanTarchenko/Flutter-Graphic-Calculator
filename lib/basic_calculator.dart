import 'package:flutter/material.dart';
import 'calculator_engine.dart';
import 'app_theme.dart';
import 'calculator_keyboard.dart';
import 'responsive_utils.dart';

class BasicCalculator extends StatefulWidget {
  final bool isDarkMode;

  const BasicCalculator({super.key, required this.isDarkMode});

  @override
  State<BasicCalculator> createState() => _BasicCalculatorState();
}

class _BasicCalculatorState extends State<BasicCalculator> {
  String _display = '0';
  String _expression = '';
  List<Map<String, String>> _history = [];

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
        final result = CalculatorEngine.evaluate(_display);
        if (result != null && !result.isInfinite && !result.isNaN) {
          final formattedResult = result % 1 == 0
              ? result.toInt().toString()
              : result.toStringAsFixed(6).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
          _display = formattedResult;
          _history.insert(0, {
            'expression': _expression,
            'result': formattedResult,
          });
          if (_history.length > 10) {
            _history.removeLast();
          }
        } else {
          _display = 'Ошибка';
        }
      } else {
        if (_display == '0' && value != '.') {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_history.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.history,
                          color: AppTheme.getSecondaryTextColor(isDark),
                          size: ResponsiveUtils.getAdaptiveFontSize(context, small: 20, medium: 24, large: 28),
                        ),
                        iconSize: ResponsiveUtils.getAdaptiveFontSize(context, small: 20, medium: 24, large: 28),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => _HistoryDialog(history: _history, isDarkMode: isDark),
                          );
                        },
                      )
                    else
                      SizedBox(width: ResponsiveUtils.getAdaptivePadding(context, small: 32, medium: 40, large: 48)),
                    Expanded(
                      child: Column(
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
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: keyboardFlex,
          child: Container(
            color: AppTheme.getKeyboardBackgroundColor(isDark),
            padding: keyboardPadding,
            child: BasicKeyboard(
              onButtonPressed: _onButtonPressed,
              isDarkMode: isDark,
            ),
          ),
        ),
      ],
    );
  }
}

class BasicKeyboard extends StatelessWidget {
  final Function(String) onButtonPressed;
  final bool isDarkMode;

  const BasicKeyboard({
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
          label: '=',
          color: Colors.green,
          onPressed: () => onButtonPressed('='),
          isDarkMode: isDarkMode,
        ),
        CalculatorButton(
          label: '+',
          color: Colors.purple,
          onPressed: () => onButtonPressed('+'),
          isDarkMode: isDarkMode,
        ),
          ],
        );
      },
    );
  }
}

class _HistoryDialog extends StatelessWidget {
  final List<Map<String, String>> history;
  final bool isDarkMode;

  const _HistoryDialog({required this.history, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.getGraphBackgroundColor(isDarkMode),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'История вычислений',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextColor(isDarkMode),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppTheme.getSecondaryTextColor(isDarkMode)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Divider(color: AppTheme.getSecondaryTextColor(isDarkMode)),
            Expanded(
              child: history.isEmpty
                  ? Center(
                      child: Text(
                        'История пуста',
                        style: TextStyle(color: AppTheme.getSecondaryTextColor(isDarkMode)),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final item = history[index];
                        return ListTile(
                          title: Text(
                            item['expression']!,
                            style: TextStyle(color: AppTheme.getSecondaryTextColor(isDarkMode)),
                          ),
                          subtitle: Text(
                            '= ${item['result']!}',
                            style: TextStyle(
                              color: AppTheme.getTextColor(isDarkMode),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
