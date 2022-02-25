import 'dart:async';

import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  late Timer _timer;
  // int _hour = 0;
  int _minute = 0;
  int _seconds = 0;
  bool _startEnable = true;
  bool _stopEnable = false;
  bool _continueEnable = false;

  bool _isTapped = false;

  // int get hour => _hour;
  int get minute => _minute;
  int get seconds => _seconds;
  bool get startEnable => _startEnable;
  bool get stopEnable => _stopEnable;
  bool get continueEnable => _continueEnable;

  bool get getisTapped => _isTapped;

  void setisTapped() {
    _isTapped = true;

    notifyListeners();
  }

  void startTimer() {
    // _hour = 0;
    _minute = 1;
    _seconds = 59;
    _startEnable = false;
    _stopEnable = true;
    _continueEnable = false;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds < 60 && _seconds > 0) {
        _seconds--;
      } else if (_seconds <= 0 && _minute > 0) {
        _seconds = 59;

        if (_minute == 59) {
          _minute = 0;
        } else {
          _minute--;
        }
      } else {
        stopTimer();
        _isTapped = false;

      }

      notifyListeners();
    });
  }

  void stopTimer() {

    if (_startEnable == false) {
      _startEnable = true;
      _continueEnable = true;
      _stopEnable = false;
      _timer.cancel();
       _isTapped = false;
    }
    notifyListeners();
  }

}
