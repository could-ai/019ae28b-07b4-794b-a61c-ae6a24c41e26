import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CalculatorScreen(),
      },
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _operand = "";
  double _num1 = 0.0;
  double _num2 = 0.0;
  bool _shouldResetDisplay = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _num1 = 0.0;
        _num2 = 0.0;
        _operand = "";
        _shouldResetDisplay = false;
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "/" ||
          buttonText == "x") {
        _num1 = double.tryParse(_output) ?? 0.0;
        _operand = buttonText;
        _shouldResetDisplay = true;
      } else if (buttonText == ".") {
        if (_shouldResetDisplay) {
          _output = "0.";
          _shouldResetDisplay = false;
        } else if (!_output.contains(".")) {
          _output = _output + buttonText;
        }
      } else if (buttonText == "=") {
        _num2 = double.tryParse(_output) ?? 0.0;

        if (_operand == "+") {
          _output = (_num1 + _num2).toString();
        } else if (_operand == "-") {
          _output = (_num1 - _num2).toString();
        } else if (_operand == "x") {
          _output = (_num1 * _num2).toString();
        } else if (_operand == "/") {
          if (_num2 == 0) {
            _output = "Error";
          } else {
            _output = (_num1 / _num2).toString();
          }
        }

        _operand = "";
        _shouldResetDisplay = true; // Result is shown, next number starts new

        // Remove .0 if it's a whole number
        if (_output.endsWith(".0")) {
          _output = _output.substring(0, _output.length - 2);
        }
      } else {
        // It's a number
        if (_output == "0" || _shouldResetDisplay) {
          _output = buttonText;
          _shouldResetDisplay = false;
        } else {
          _output = _output + buttonText;
        }
      }
    });
  }

  Widget _buildButton(String buttonText, {Color? backgroundColor, Color? textColor}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            backgroundColor: backgroundColor ?? Colors.grey.shade200,
            foregroundColor: textColor ?? Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 2,
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // Display Area
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24.0),
              width: double.infinity,
              color: Colors.white,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  _output,
                  style: const TextStyle(
                    fontSize: 64.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Keypad Area
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.grey.shade50,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("C", backgroundColor: Colors.red.shade400, textColor: Colors.white),
                        _buildButton("/", backgroundColor: Colors.orange, textColor: Colors.white),
                        _buildButton("x", backgroundColor: Colors.orange, textColor: Colors.white),
                        _buildButton("-", backgroundColor: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("7"),
                        _buildButton("8"),
                        _buildButton("9"),
                        _buildButton("+", backgroundColor: Colors.orange, textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("4"),
                        _buildButton("5"),
                        _buildButton("6"),
                        // Placeholder to fill grid or span rows if needed, 
                        // but for simple grid we can just repeat equal or have empty
                        // Let's make the equal button span vertically or just put it at bottom
                        // Standard layout usually has + spanning or = spanning.
                        // Let's stick to 4x5 grid logic or similar.
                        // Actually, let's just put = in the bottom right corner
                         _buildButton("=", backgroundColor: Colors.green, textColor: Colors.white),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton("1"),
                        _buildButton("2"),
                        _buildButton("3"),
                        // We need another button here to keep grid aligned if we want
                        // Let's move = to bottom and put something else here?
                        // Actually, let's reorganize to standard 4x5
                        // Row 1: C / x - (Wait, usually C is top left)
                        // Row 2: 7 8 9 +
                        // Row 3: 4 5 6 - (Wait, operators usually on right column)
                        
                        // Let's re-do the rows for standard layout:
                        // Row 1: C  (spacer) (spacer) /
                        // Row 2: 7 8 9 x
                        // Row 3: 4 5 6 -
                        // Row 4: 1 2 3 +
                        // Row 5: 0 . =
                        
                        // My previous layout was a bit mixed. Let's fix it in the next rows.
                         _buildButton("."), // Moved . here for now
                      ],
                    ),
                  ),
                   Expanded(
                    child: Row(
                      children: [
                        // Zero usually spans two columns
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.all(6.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 22.0),
                                backgroundColor: Colors.grey.shade200,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () => _buttonPressed("0"),
                              child: const Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                         _buildButton("00"),
                         // We have one spot left. 
                         // Let's just clean up the layout entirely in the code below to be standard.
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
