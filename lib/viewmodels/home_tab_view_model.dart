import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

import 'package:nigiru_kun/usecases/count_use_case.dart';
import 'package:nigiru_kun/utils/color.dart';

class HomeTabViewModel extends Model {
  CountUseCase _countUseCase = CountUseCase();
  Observable<int> countSubject;

  int _currentGripNum = 0;
  int _goalGripNum = 100;
  int _weight = 20;

  String get today {
    final today = DateTime.now();
    var formatter = new DateFormat('yyyy.MM.dd');
    return formatter.format(today);
  }

  int get currentGripNum => _currentGripNum;

  int get goalGripNum => _goalGripNum;

  int get weight => _weight;

  double get achievementRate => _currentGripNum / _goalGripNum;

  void init() {
    _countUseCase.observeTodayCount.listen((sum) {
      _currentGripNum = sum;
      notifyListeners();
    });
    _countUseCase.observetThreshWeight.listen((weight) {
      if (_weight != weight) {
        _weight = weight.toInt();
        notifyListeners();
      }
    });
    _countUseCase.observetGoal.listen((goal) {
      _goalGripNum = goal;
      notifyListeners();
    });
  }

  void dispose() {}

  void setWeight(String value) {
    final num = value == '' ? 0 : int.parse(value);
    if (num == null || num < 3) {
      _weight = 3;
    } else if (num > 100) {
      _weight = 100;
    } else {
      _weight = num;
    }
    _countUseCase.setThreshWeight(_weight.toDouble());
    notifyListeners();
  }

  void setGoalGripNum(String value) {
    if (value == '') {
      _goalGripNum = 0;
    } else {
      _goalGripNum = int.parse(value);
    }
    _countUseCase.setGoal(_goalGripNum);
    notifyListeners();
  }

  Color get counterColor {
    if (achievementRate.toInt() % 2 == 0) {
      return CustomColors.primaryColor;
    }
    return CustomColors.orange;
  }

  Color get counterBackgroundColor {
    if (achievementRate < 1) {
      return CustomColors.primaryTranslucentColor;
    }
    if (achievementRate.toInt() % 2 == 0) {
      return CustomColors.orange;
    }
    return CustomColors.primaryColor;
  }
}
