import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/status_type.dart';
import 'package:health_app_2/data/models/food_model.dart';
import 'package:health_app_2/data/models/steps_model.dart';
import 'package:health_app_2/data/models/user_model.dart';
import 'package:health_app_2/data/models/water_model.dart';
import 'package:health_app_2/data/repositories/auth_repository.dart';
import 'package:health_app_2/data/repositories/health_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HealthRepository healthRepository;
  final AuthRepository authRepository;

  HomeProvider({
    required this.healthRepository,
    required this.authRepository,
  });

  UserModel? userData;
  StepsModel? stepData;
  WaterModel? waterData;
  int maxHeartRate = 0;
  int minHeartRate = 0;
  int divHeartRate = 0;
  int sumCalories = 0;
  final List<int> heartRateList = [];
  final List<FoodModel> foodDataList = [];

  int addWater = 200;

  late TextEditingController targetValue;
  bool targetValueError = false;

  void init() {
    targetValue = TextEditingController();

    getProfile();
    getSteps();
    getWaterIntake();
    getHeartRate();
    getFoodData();
    notifyListeners();
  }

  void getProfile() async {
    final result = await authRepository.getUserProfile();

    if (result.isRight()) {
      userData = result.right();
      notifyListeners();
      return;
    }

    log(result.left().toString());
  }

  void getSteps() async {
    final result = await healthRepository.getSteps();

    if (result.isRight()) {
      final stepsModel = result.right();
      if (stepsModel.stepGoal != null &&
          stepsModel.currentSteps != null &&
          stepsModel.stepGoal != 0) {
        stepData = stepsModel;
      } else {
        stepData = null;
      }
      notifyListeners();
      return;
    }

    log(result.left().toString());
  }

  void getWaterIntake() async {
    final result = await healthRepository.getWaterIntake();

    if (result.isRight()) {
      final waterModel = result.right();
      print(waterModel.toString());
      if (waterModel.waterGoal != null &&
          waterModel.currentWater != null &&
          waterModel.waterGoal != 0) {
        waterData = waterModel;
      } else {
        print('dfdf');
        waterData = null;
      }
      notifyListeners();
      return;
    }

    log(result.left().toString());
  }

  void getHeartRate() async {
    final result = await healthRepository.getHeartRate();

    if (result.isRight()) {
      heartRateList.clear();
      heartRateList.addAll(result.right());

      minHeartRate = heartRateList[0];
      maxHeartRate = heartRateList[0];

      for (int val in heartRateList) {
        divHeartRate += val;
        if (val < minHeartRate) {
          minHeartRate = val;
        } else if (val > maxHeartRate) {
          maxHeartRate = val;
        }
      }
      divHeartRate = (divHeartRate / heartRateList.length).floor();
      notifyListeners();
      return;
    }

    log(result.left().toString());
  }

  void getFoodData() async {
    final result = await healthRepository.getFoodData();

    if (result.isRight()) {
      sumCalories = 0;
      foodDataList.clear();
      foodDataList.addAll(result.right());

      for (FoodModel val in foodDataList) {
        sumCalories += val.calories;
      }

      notifyListeners();
      return;
    }

    log(result.left().toString());
  }

  Future<StatusType> setCurrentWater() async {
    final int water = waterData!.currentWater! + addWater;

    final body = {'current_water_intake': water};

    final result = await healthRepository.setWaterCurrent(body);
    addWater = 200;

    getWaterIntake();

    notifyListeners();
    return StatusType.fromStatusCode(result.statusCode);
  }

  void addAndRemoveWater(bool isAdd) {
    if (isAdd && addWater < 1000) {
      addWater += 50;
      notifyListeners();
    } else if (!isAdd && addWater > 50) {
      addWater -= 50;
      notifyListeners();
    }
  }

  Future<StatusType> editGoal() async {
    if (targetValue.text.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(targetValue.text)) {
      targetValueError = true;
    } else {
      targetValueError = false;
    }

    if (!targetValueError) {
      final body = {'water_goal' : int.parse(targetValue.text)};

      final result = await healthRepository.setWaterGoal(body);
      return StatusType.fromStatusCode(result.statusCode);
    }


    notifyListeners();
    return StatusType.internalSeverError;
  }

  String bmiToText(double bmi) {
    print(bmi);

    if (bmi < 18.5) {
      return '저체중';
    } else if (18.5 < bmi && bmi < 23) {
      return '정상';
    } else if (23 < bmi && bmi < 25) {
      return '과체중';
    } else if (25 < bmi) {
      return '비만';
    }

    return '알수없음';
  }
}
