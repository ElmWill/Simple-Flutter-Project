import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculator());
}

class BMICalculator extends StatelessWidget {
  const BMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BMIHomePage(),
    );
  }
}

class BMIHomePage extends StatefulWidget {
  const BMIHomePage({super.key});

  @override
  _BMIHomePageState createState() => _BMIHomePageState();
}

class _BMIHomePageState extends State<BMIHomePage> {
  double _height = 0; // in centimeters
  double _weight = 0; // in kilograms
  double _bmi = 0;

  late Timer _timer;
  Color _backgroundColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _backgroundColor = _getRandomColor();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          title: Row(
            children: [
              Container(
                color: Colors.blue,
                height: 21,
                width: 4,
              ),
              const Text('BMI Calculator'),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            color: _backgroundColor,
            curve: Curves.easeInOut,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color.fromARGB(255, 249, 249, 249),
                  BlendMode.saturation,
                ),
                child: Opacity(
                  opacity: 0,
                  child: Container(
                    color: const Color.fromARGB(255, 227, 43, 43),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Calculate your BMI',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Height (cm): ',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            key: const Key('heightField'),
                            keyboardType: TextInputType.number,
                            initialValue: _height.toString(),
                            onChanged: (value) {
                              setState(() {
                                _height = double.parse(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Weight (kg): ',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            key: const Key('weightField'),
                            keyboardType: TextInputType.number,
                            initialValue: _weight.toString(),
                            onChanged: (value) {
                              setState(() {
                                _weight = double.parse(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      key: const Key('calculateButton'),
                      onPressed: () {
                        setState(() {
                          _bmi = _calculateBMI(_height, _weight);
                        });
                      },
                      child: const Text('Calculate'),
                    ),
                    const SizedBox(height: 20),
                    _bmi > 0
                        ? Column(
                            children: [
                              Text(
                                'Your BMI: ${_bmi.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _getBMIStatus(_bmi),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _getBMIStatusColor(_bmi),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateBMI(double height, double weight) {
    return weight / ((height / 100) * (height / 100));
  }

  String _getBMIStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }

  Color _getBMIStatusColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi >= 18.5 && bmi < 25) {
      return Colors.green;
    } else if (bmi >= 25 && bmi < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getRandomColor() {
    return Color(DateTime.now().millisecondsSinceEpoch ~/ 10 & 0xFFFFFFFF);
  }
}
