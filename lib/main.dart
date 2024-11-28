import 'package:flutter/material.dart';
import 'dart:async'; // for using Future.delayed

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: const SplashScreen(), // Splash screen as the initial screen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds to show the splash screen before navigating
    Future.delayed(const Duration(seconds: 3), () {
      // Use WidgetsBinding to safely call Navigator after the widget has built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Calculator')),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple, // Splash screen background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Calculator App!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String display = "0";  // Display result or input
  double firstOperand = 0; // First operand for the operation
  String currentOperation = ""; // Current operation (+, -, *, /)

  // Update the display with the pressed button
  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = "0";
        firstOperand = 0;
        currentOperation = "";
      } else if (value == '=') {
        double secondOperand = double.parse(display);
        switch (currentOperation) {
          case '+':
            display = (firstOperand + secondOperand).toString();
            break;
          case '-':
            display = (firstOperand - secondOperand).toString();
            break;
          case '*':
            display = (firstOperand * secondOperand).toString();
            break;
          case '/':
            if (secondOperand != 0) {
              display = (firstOperand / secondOperand).toString();
            } else {
              display = "ERROR";
            }
            break;
        }
        currentOperation = "";
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        firstOperand = double.parse(display);
        currentOperation = value;
        display = "0";
      } else {
        if (display == "0") {
          display = value;
        } else {
          display += value;
        }
      }
    });
  }

  // Build calculator buttons with custom styles
  Widget buildButton(String value, {Color color = Colors.blue}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => onButtonPressed(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Use backgroundColor instead of primary
          padding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          value,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Display for the current input/result
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              display,
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
          // Calculator buttons layout
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    buildButton('7', color: Colors.blueAccent),
                    buildButton('8', color: Colors.blueAccent),
                    buildButton('9', color: Colors.blueAccent),
                    buildButton('/', color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    buildButton('4', color: Colors.blueAccent),
                    buildButton('5', color: Colors.blueAccent),
                    buildButton('6', color: Colors.blueAccent),
                    buildButton('*', color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    buildButton('1', color: Colors.blueAccent),
                    buildButton('2', color: Colors.blueAccent),
                    buildButton('3', color: Colors.blueAccent),
                    buildButton('-', color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    buildButton('C', color: Colors.red),
                    buildButton('0', color: Colors.blueAccent),
                    buildButton('=', color: Colors.green),
                    buildButton('+', color: Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
