import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TimerProvider with ChangeNotifier {
  late Timer _timer;

  int _minute = 0;
  int _seconds = 0;
  bool _startEnable = true;
  bool _stopEnable = false;

  int get minute => _minute;
  int get seconds => _seconds;
  bool get startEnable => _startEnable;
  bool get stopEnable => _stopEnable;

  void startTimer() {
    _minute = 1;
    _seconds = 10;
    _startEnable = false;
    _stopEnable = true;
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      
      if (!_startEnable) {
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
          _timer.cancel();
          _startEnable = true;
        }

        notifyListeners();
      }
    });
  }

  void stopTimer() {
    Logger().w(" >>>>>>>>> timer is : " + _startEnable.toString());
    if (_startEnable == false) {
      _startEnable = true;

      _stopEnable = false;

      _seconds = 0;
      _minute = 0;
    }
 
    _timer.cancel();
    notifyListeners();
  }
 
}
