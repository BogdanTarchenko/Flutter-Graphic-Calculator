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
    
    expression = expression.replaceAllMapped(
      RegExp(r'ln\(([^)]+)\)'),
      (match) {
        final arg = match.group(1)!;
        final value = _evaluateExpression(arg);
        return value != null && value > 0 ? math.log(value).toString() : '0';
      },
    );
    
    expression = expression.replaceAllMapped(
      RegExp(r'log\(([^)]+)\)'),
      (match) {
        final arg = match.group(1)!;
        final value = _evaluateExpression(arg);
        return value != null && value > 0 ? (math.log(value) / math.log(10)).toString() : '0';
      },
    );
    
    expression = expression.replaceAllMapped(
      RegExp(r'sqrt\(([^)]+)\)'),
      (match) {
        final arg = match.group(1)!;
        final value = _evaluateExpression(arg);
        return value != null && value >= 0 ? math.sqrt(value).toString() : '0';
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
      
      if (!_isValidExpression(expression)) return null;
      
      expression = _processNegativeNumbers(expression);
      
      List<String> tokens = _tokenize(expression);
      if (tokens.isEmpty) return null;
      
      List<double> numbers = [];
      List<String> operators = [];
      
      for (String token in tokens) {
        if (_isNumber(token)) {
          try {
            numbers.add(double.parse(token));
          } catch (e) {
            return null;
          }
        } else if (token == '(') {
          operators.add(token);
        } else if (token == ')') {
          if (operators.isEmpty) return null;
          while (operators.isNotEmpty && operators.last != '(') {
            if (!_applyOperator(numbers, operators)) return null;
          }
          if (operators.isEmpty) return null;
          operators.removeLast();
        } else if (_isOperator(token)) {
          while (operators.isNotEmpty &&
              _precedence(operators.last) >= _precedence(token) &&
              operators.last != '(') {
            if (!_applyOperator(numbers, operators)) return null;
          }
          operators.add(token);
        }
      }
      
      while (operators.isNotEmpty) {
        if (!_applyOperator(numbers, operators)) return null;
      }
      
      if (numbers.isEmpty) return null;
      final result = numbers.first;
      if (result.isInfinite || result.isNaN) return null;
      return result;
    } catch (e) {
      return null;
    }
  }

  static bool _isValidExpression(String expression) {
    if (expression.isEmpty) return false;
    
    int openParens = 0;
    for (int i = 0; i < expression.length; i++) {
      if (expression[i] == '(') openParens++;
      if (expression[i] == ')') {
        openParens--;
        if (openParens < 0) return false;
      }
    }
    if (openParens != 0) return false;
    
    if (RegExp(r'[+\-*/]{2,}').hasMatch(expression)) return false;
    if (RegExp(r'[+\-*/]$').hasMatch(expression)) return false;
    
    return true;
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

  static bool _applyOperator(List<double> numbers, List<String> operators) {
    if (numbers.length < 2 || operators.isEmpty) return false;
    
    String op = operators.removeLast();
    double b = numbers.removeLast();
    double a = numbers.removeLast();
    
    try {
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
          if (b == 0) return false;
          numbers.add(a / b);
          break;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
