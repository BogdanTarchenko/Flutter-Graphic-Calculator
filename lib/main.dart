import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'calculator_engine.dart';
import 'graph_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const GraphicCalculatorApp());
}

class GraphicCalculatorApp extends StatelessWidget {
  const GraphicCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Графический калькулятор',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        cardColor: const Color(0xFF1A1F3A),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  List<Map<String, String>> _history = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_history.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.history, color: Colors.grey),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => _HistoryDialog(history: _history),
                              );
                            },
                          )
                        else
                          const SizedBox(width: 48),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _expression.isEmpty ? '' : _expression,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _display,
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
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
              flex: 3,
              child: Container(
                color: const Color(0xFF1A1F3A),
                child: GraphWidget(
                  function: _expression.contains('x') ? _expression : null,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: const Color(0xFF0A0E27),
                padding: const EdgeInsets.all(16),
                child: CalculatorKeyboard(
                  onButtonPressed: (String value) {
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
                        if (_display == '0' && value != '.' && value != 'x') {
                          _display = value;
                        } else if (_display == 'Ошибка') {
                          _display = value;
                        } else {
                          _display += value;
                        }
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorKeyboard extends StatelessWidget {
  final Function(String) onButtonPressed;

  const CalculatorKeyboard({
    super.key,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _CalculatorButton(
          label: 'C',
          color: Colors.red,
          onPressed: () => onButtonPressed('C'),
        ),
        _CalculatorButton(
          label: '⌫',
          color: Colors.orange,
          onPressed: () => onButtonPressed('⌫'),
        ),
        _CalculatorButton(
          label: '(',
          color: Colors.blue,
          onPressed: () => onButtonPressed('('),
        ),
        _CalculatorButton(
          label: ')',
          color: Colors.blue,
          onPressed: () => onButtonPressed(')'),
        ),
        _CalculatorButton(
          label: '7',
          onPressed: () => onButtonPressed('7'),
        ),
        _CalculatorButton(
          label: '8',
          onPressed: () => onButtonPressed('8'),
        ),
        _CalculatorButton(
          label: '9',
          onPressed: () => onButtonPressed('9'),
        ),
        _CalculatorButton(
          label: '÷',
          color: Colors.purple,
          onPressed: () => onButtonPressed('/'),
        ),
        _CalculatorButton(
          label: '4',
          onPressed: () => onButtonPressed('4'),
        ),
        _CalculatorButton(
          label: '5',
          onPressed: () => onButtonPressed('5'),
        ),
        _CalculatorButton(
          label: '6',
          onPressed: () => onButtonPressed('6'),
        ),
        _CalculatorButton(
          label: '×',
          color: Colors.purple,
          onPressed: () => onButtonPressed('*'),
        ),
        _CalculatorButton(
          label: '1',
          onPressed: () => onButtonPressed('1'),
        ),
        _CalculatorButton(
          label: '2',
          onPressed: () => onButtonPressed('2'),
        ),
        _CalculatorButton(
          label: '3',
          onPressed: () => onButtonPressed('3'),
        ),
        _CalculatorButton(
          label: '-',
          color: Colors.purple,
          onPressed: () => onButtonPressed('-'),
        ),
        _CalculatorButton(
          label: '0',
          onPressed: () => onButtonPressed('0'),
        ),
        _CalculatorButton(
          label: '.',
          onPressed: () => onButtonPressed('.'),
        ),
        _CalculatorButton(
          label: 'x',
          color: Colors.teal,
          onPressed: () => onButtonPressed('x'),
        ),
        _CalculatorButton(
          label: '+',
          color: Colors.purple,
          onPressed: () => onButtonPressed('+'),
        ),
        _CalculatorButton(
          label: 'sin',
          color: Colors.indigo,
          onPressed: () => onButtonPressed('sin('),
        ),
        _CalculatorButton(
          label: 'cos',
          color: Colors.indigo,
          onPressed: () => onButtonPressed('cos('),
        ),
        _CalculatorButton(
          label: '^',
          color: Colors.purple,
          onPressed: () => onButtonPressed('^'),
        ),
        _CalculatorButton(
          label: '=',
          color: Colors.green,
          onPressed: () => onButtonPressed('='),
        ),
      ],
    );
  }
}

class _CalculatorButton extends StatefulWidget {
  final String label;
  final Color? color;
  final VoidCallback onPressed;

  const _CalculatorButton({
    required this.label,
    this.color,
    required this.onPressed,
  });

  @override
  State<_CalculatorButton> createState() => __CalculatorButtonState();
}

class __CalculatorButtonState extends State<_CalculatorButton>
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
    final buttonColor = widget.color ?? Colors.grey[800]!;
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: buttonColor,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: buttonColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryDialog extends StatelessWidget {
  final List<Map<String, String>> history;

  const _HistoryDialog({required this.history});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1F3A),
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
                const Text(
                  'История вычислений',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            Expanded(
              child: history.isEmpty
                  ? const Center(
                      child: Text(
                        'История пуста',
                        style: TextStyle(color: Colors.grey),
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
                            style: const TextStyle(color: Colors.grey),
                          ),
                          subtitle: Text(
                            '= ${item['result']!}',
                            style: const TextStyle(
                              color: Colors.white,
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
