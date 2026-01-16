import 'dart:math' as math;

class CalculatorEngine {
  static double? evaluate(String expression, {double? xValue}) {
    try {
      String processed = expression.replaceAll(' ', '');
      
      if (xValue != null) {
        processed = processed.replaceAll('x', xValue.toString());
      }
      
      processed = _replaceFunctions(processed);
      processed = _replacePower(processed);
      
      return _evaluateExpression(processed);
    } catch (e) {
      return null;
    }
  }

  static String _replaceFunctions(String expression) {
    expression = expression.replaceAllMapped(
      RegExp(r'sin\(([^)]+)\)'),
      (match) {
        final arg = match.group(1)!;
        final value = _evaluateExpression(arg);
        return value != null ? math.sin(value).toString() : '0';
      },
    );
    
    expression = expression.replaceAllMapped(
      RegExp(r'cos\(([^)]+)\)'),
      (match) {
        final arg = match.group(1)!;
        final value = _evaluateExpression(arg);
        return value != null ? math.cos(value).toString() : '0';
      },
    );
    
    expression = expression.replaceAllMapped(
      RegExp(r'tan\(([^)]+)\)'),
      (match) {
        final arg = match.group(1)!;
        final value = _evaluateExpression(arg);
        return value != null ? math.tan(value).toString() : '0';
      },
    );
    
    return expression;
  }

  static String _replacePower(String expression) {
    return expression.replaceAllMapped(
      RegExp(r'(\d+\.?\d*)\^(\d+\.?\d*)'),
      (match) {
        final base = double.parse(match.group(1)!);
        final exp = double.parse(match.group(2)!);
        return math.pow(base, exp).toString();
      },
    );
  }

  static double? _evaluateExpression(String expression) {
    try {
      if (expression.isEmpty) return null;
      
      expression = _processNegativeNumbers(expression);
      
      List<String> tokens = _tokenize(expression);
      List<double> numbers = [];
      List<String> operators = [];
      
      for (String token in tokens) {
        if (_isNumber(token)) {
          numbers.add(double.parse(token));
        } else if (token == '(') {
          operators.add(token);
        } else if (token == ')') {
          while (operators.isNotEmpty && operators.last != '(') {
            _applyOperator(numbers, operators);
          }
          operators.removeLast();
        } else if (_isOperator(token)) {
          while (operators.isNotEmpty &&
              _precedence(operators.last) >= _precedence(token) &&
              operators.last != '(') {
            _applyOperator(numbers, operators);
          }
          operators.add(token);
        }
      }
      
      while (operators.isNotEmpty) {
        _applyOperator(numbers, operators);
      }
      
      return numbers.isEmpty ? null : numbers.first;
    } catch (e) {
      return null;
    }
  }

  static String _processNegativeNumbers(String expression) {
    if (expression.startsWith('-')) {
      expression = '0$expression';
    }
    expression = expression.replaceAll('(-', '(0-');
    expression = expression.replaceAll('*-', '*0-');
    expression = expression.replaceAll('/-', '/0-');
    expression = expression.replaceAll('+-', '+0-');
    return expression;
  }

  static List<String> _tokenize(String expression) {
    List<String> tokens = [];
    String currentNumber = '';
    
    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      
      if (_isDigit(char) || char == '.') {
        currentNumber += char;
      } else {
        if (currentNumber.isNotEmpty) {
          tokens.add(currentNumber);
          currentNumber = '';
        }
        tokens.add(char);
      }
    }
    
    if (currentNumber.isNotEmpty) {
      tokens.add(currentNumber);
    }
    
    return tokens;
  }

  static bool _isNumber(String s) {
    try {
      double.parse(s);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool _isDigit(String s) {
    return s.length == 1 && s.codeUnitAt(0) >= 48 && s.codeUnitAt(0) <= 57;
  }

  static bool _isOperator(String s) {
    return s == '+' || s == '-' || s == '*' || s == '/';
  }

  static int _precedence(String op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    return 0;
  }

  static void _applyOperator(List<double> numbers, List<String> operators) {
    if (numbers.length < 2 || operators.isEmpty) return;
    
    String op = operators.removeLast();
    double b = numbers.removeLast();
    double a = numbers.removeLast();
    
    switch (op) {
      case '+':
        numbers.add(a + b);
        break;
      case '-':
        numbers.add(a - b);
        break;
      case '*':
        numbers.add(a * b);
        break;
      case '/':
        if (b != 0) {
          numbers.add(a / b);
        } else {
          numbers.add(double.infinity);
        }
        break;
    }
  }
}
