import 'package:assignment_2/calculator_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => CalculatorProvider(),
    child: const CalculatorApp(),
  ));
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          //History Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                context.watch<CalculatorProvider>().history,
                style: const TextStyle(color: Colors.white70, fontSize: 24),
              ),
            ),
          ),


          // Display Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                context.watch<CalculatorProvider>().display,
                style: const TextStyle(color: Colors.white, fontSize: 80),
                maxLines: 1,  // Ensure it stays on one line
                overflow: TextOverflow.ellipsis,  // Add ellipsis if text exceeds the width
              ),
            ),
          ),


          // Buttons Section
          buildButtonRow(context, ["AC", "+/-", "%", "÷"], [Colors.grey.shade600, Colors.grey.shade600, Colors.grey.shade600, Colors.orange]),
          buildButtonRow(context, ["7", "8", "9", "×"], [Colors.white12, Colors.white12, Colors.white12, Colors.orange]),
          buildButtonRow(context, ["4", "5", "6", "-"], [Colors.white12, Colors.white12, Colors.white12, Colors.orange]),
          buildButtonRow(context, ["1", "2", "3", "+"], [Colors.white12, Colors.white12, Colors.white12, Colors.orange]),
          buildButtonRow(context, ["0", ".", "="], [Colors.white12, Colors.white12, Colors.orange], isLastRow: true),
        ],
      ),
    );
  }

  Widget buildButtonRow(BuildContext context, List<String> labels, List<Color> colors, {bool isLastRow = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.map((label) {
        bool isZero = label == "0";
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          child: isZero && isLastRow
              ? buildWideButton(context, label, colors[labels.indexOf(label)])
              : buildButton(context, label, colors[labels.indexOf(label)]),
        );
      }).toList(),
    );
  }

  Widget buildButton(BuildContext context, String label, Color color) {
    double fontSize = (label == "AC" || label == "+/-") ? 24 : 32;

    return Container(
      width: 80, // Adjusted width for uniform button sizes
      height: 80, // Adjusted height for uniform button sizes
      child: ElevatedButton(
        onPressed: () {
          context.read<CalculatorProvider>().onButtonPressed(label);
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20), // Reduced padding for round buttons
          backgroundColor: color,
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: fontSize, color: Colors.white), // Conditional font size
        ),
      ),
    );
  }


  Widget buildWideButton(BuildContext context, String label, Color color) {
    return Container(
      width: 180, // Wider width for the "0" button
      height: 80,  // Same height as other buttons
      child: ElevatedButton(
        onPressed: () {
          context.read<CalculatorProvider>().onButtonPressed(label);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40), // Rounded edges for the "0" button
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30), // Adjusted padding for wider button
          backgroundColor: color,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 32, color: Colors.white),
        ),
      ),
    );
  }
}
