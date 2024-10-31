import 'package:flutter/material.dart';

class CalculatorProvider with ChangeNotifier {
  String _display = '0';
  String _history = '';
  String _operand1 = '';
  String _operand2 = '';
  String _operator = '';

  String get display => _display;
  String get history => _history;

  void onButtonPressed(String label) {
    if (_isOperator(label)) {
      _operator = label;
      _operand1 = _display;
      _display = '0';
    } else if (label == '=') {
      _operand2 = _display;
      _calculateResult();
    } else if (label == 'AC') {
      _clear();
    } else if (label == '+/-') {
      _toggleSign();
    } else if (label == '%') {
      _calculatePercentage();
    } else {
      _updateDisplay(label);
    }
    notifyListeners();
  }

  void _calculateResult() {
    double result = 0.0;
    double num1 = double.parse(_operand1);
    double num2 = double.parse(_operand2);

    switch (_operator) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '×':
        result = num1 * num2;
        break;
      case '÷':
        result = num2 != 0 ? num1 / num2 : 0;
        break;
    }
    String resultStr = result.toStringAsFixed(6);
    // Remove trailing zeros if applicable
    _display = resultStr.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");

    _history += '$_operand1 $_operator $_operand2 = $_display\n';
  }

  void _clear() {
    _display = '0';
    _operand1 = '';
    _operand2 = '';
    _operator = '';
    _history = '';
  }

  void _toggleSign() {
    if (_display.startsWith('-')) {
      _display = _display.substring(1);
    } else {
      _display = '-$_display';
    }
  }

  void _calculatePercentage() {
    double currentNumber = double.parse(_display);
    _display = (currentNumber / 100).toString();
  }

  void _updateDisplay(String digit) {
    if (_display == '0') {
      _display = digit;
    } else {
      _display += digit;
    }
  }

  bool _isOperator(String label) {
    return label == '+' || label == '-' || label == '×' || label == '÷';
  }
}
