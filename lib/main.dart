```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ù',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1E88E5),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF1E88E5),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
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
  double? _firstOperand;
  String? _operator;
  bool _waitingForSecondOperand = false;

  void _clear() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = null;
      _operator = null;
      _waitingForSecondOperand = false;
    });
  }

  void _delete() {
    if (_display.length > 1) {
      setState(() {
        _display = _display.substring(0, _display.length - 1);
      });
    } else {
      setState(() {
        _display = '0';
      });
    }
  }

  void _inputDigit(String digit) {
    setState(() {
      if (_waitingForSecondOperand) {
        _display = digit;
        _waitingForSecondOperand = false;
      } else {
        _display = _display == '0' ? digit : _display + digit;
      }
    });
  }

  void _inputDecimal() {
    if (!_display.contains('.')) {
      setState(() {
        if (_waitingForSecondOperand) {
          _display = '0.';
          _waitingForSecondOperand = false;
        } else {
          _display += '.';
        }
      });
    }
  }

  void _performOperation(String op) {
    final currentNumber = double.tryParse(_display);
    if (currentNumber == null) return;

    if (_operator != null && !_waitingForSecondOperand) {
      _calculate();
    }

    setState(() {
      _firstOperand = double.parse(_display);
      _operator = op;
      _expression = '$_display $op';
      _waitingForSecondOperand = true;
    });
  }

  void _calculate() {
    final secondOperand = double.tryParse(_display);
    if (_firstOperand == null || _operator == null || secondOperand == null) return;

    double result;
    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case 'Ã':
        result = _firstOperand! * secondOperand;
        break;
      case 'Ã·':
        if (secondOperand == 0) {
          setState(() {
            _display = 'Ø®Ø·Ø£';
            _expression = '';
            _firstOperand = null;
            _operator = null;
            _waitingForSecondOperand = false;
          });
          return;
        }
        result = _firstOperand! / secondOperand;
        break;
      default:
        return;
    }

    setState(() {
      _display = result == result.truncateToDouble()
          ? result.toStringAsFixed(0)
          : result.toString();
      _expression = '$_firstOperand $_operator $secondOperand =';
      _firstOperand = result;
      _operator = null;
      _waitingForSecondOperand = true;
    });
  }

  void _toggleSign() {
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else if (_display != '0') {
        _display = '-' + _display;
      }
    });
  }

  void _percent() {
    final value = double.tryParse(_display);
    if (value != null) {
      setState(() {
        _display = (value / 100).toString();
      });
    }
  }

  void _squareRoot() {
    final value = double.tryParse(_display);
    if (value != null && value >= 0) {
      setState(() {
        final result = value == 0 ? 0.0 : value.toString();
        _display = value.toString();
        _expression = 'â($result) =';
        _display = value.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ù'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(
                      fontSize: 24,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _display,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildButtonRow(
                  ['C', 'â«', '%', 'Ã·'],
                  colorScheme,
                  isTopRow: true,
                ),
                const SizedBox(height: 8),
                _buildButtonRow(
                  ['7', '8', '9', 'Ã'],
                  colorScheme,
                ),
                const SizedBox(height: 8),
                _buildButtonRow(
                  ['4', '5', '6', '-'],
                  colorScheme,
                ),
                const SizedBox(height: 8),
                _buildButtonRow(
                  ['1', '2', '3', '+'],
                  colorScheme,
                ),
                const SizedBox(height: 8),
                _buildButtonRow(
                  ['Â±', '0', '.', '='],
                  colorScheme,
                  isLastRow: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(
    List<String> labels,
    ColorScheme colorScheme, {
    bool isTopRow = false,
    bool isLastRow = false,
  }) {
    return Row(
      children: labels.map((label) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildButton(
              label,
              colorScheme,
              isTopRow: isTopRow,
              isLastRow: isLastRow,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildButton(
    String label,
    ColorScheme colorScheme, {
    bool isTopRow = false,
    bool isLastRow = false,
  }) {
    final bool isOperator = ['+', '-', 'Ã', 'Ã·', '='].contains(label);
    final bool isClear = label == 'C';
    final bool isDelete = label == 'â«';
    final bool isFunction = isTopRow || label == 'Â±' || label == '%';

    Color? backgroundColor;
    Color? foregroundColor;

    if (isOperator) {
      backgroundColor = colorScheme.primary;
      foregroundColor = colorScheme.onPrimary;
    } else if (isFunction) {
      backgroundColor = colorScheme.secondaryContainer;
      foregroundColor = colorScheme.onSecondaryContainer;
    } else {
      backgroundColor = colorScheme.surfaceVariant;
      foregroundColor = colorScheme.onSurfaceVariant;
    }

    if (isClear) {
      backgroundColor = colorScheme.errorContainer;
      foregroundColor = colorScheme.onErrorContainer;
    }

    return SizedBox(
      height: 72,
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isOperator ? 28 : 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(String label) {
    switch (label) {
      case 'C':
        _clear();
        break;
      case 'â«':
        _delete();
        break;
      case 'Â±':
        _toggleSign();
        break;
      case '%':
        _percent();
        break;
      case 'â':
        _squareRoot();
        break;
      case '+':
      case '-':
      case 'Ã':
      case 'Ã·':
        _performOperation(label);
        break;
      case '=':
        _calculate();
        break;
      case '.':
        _inputDecimal();
        break;
      default:
        _inputDigit(label);
        break;
    }
  }
}
```