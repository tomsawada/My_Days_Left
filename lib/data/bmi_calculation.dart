import 'dart:math';

class BmiCalculation {
  BmiCalculation({this.height, this.weight});

  final int height;
  final int weight;

  double _bmi;

  String calculateBmiImperial() {
    _bmi = (weight / pow(height * 1.2, 2)) * 703;
    return _bmi.toStringAsFixed(1);
  }

  String calculateBmiMetric() {
    _bmi = (weight / pow(height / 100, 2));
    return _bmi.toStringAsFixed(1);
  }

  double resultMaleBMI() {
    if (_bmi >= 40.0) {
      return -9.1;
    } else if (_bmi >= 35.0) {
      return -5.9;
    } else if (_bmi >= 30.0) {
      return -3.4;
    } else if (_bmi >= 25.0) {
      return -1;
    } else if (_bmi > 18.5) {
      return 0;
    } else {
      return -4.3;
    }
  }

  double resultFemaleBMI() {
    if (_bmi >= 40.0) {
      return -7.7;
    } else if (_bmi >= 35.0) {
      return -4.7;
    } else if (_bmi >= 30.0) {
      return -2.4;
    } else if (_bmi >= 25.0) {
      return -0.8;
    } else if (_bmi > 18.5) {
      return 0;
    } else {
      return -4.5;
    }
  }
}
