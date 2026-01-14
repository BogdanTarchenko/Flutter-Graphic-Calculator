import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                    Text(
                      _expression.isEmpty ? '' : _expression,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _display,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: const Color(0xFF1A1F3A),
                child: const Center(
                  child: Text(
                    'График появится здесь',
                    style: TextStyle(color: Colors.grey),
                  ),
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
                      } else if (value == '=') {
                        _expression = _display;
                      } else {
                        if (_display == '0' && value != '.') {
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

class _CalculatorButton extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback onPressed;

  const _CalculatorButton({
    required this.label,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? Colors.grey[800]!;
    
    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
