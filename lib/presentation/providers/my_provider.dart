import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/core/utils/status_type.dart';
import 'package:health_app_2/data/models/steps_model.dart';
import 'package:health_app_2/data/models/user_model.dart';
import 'package:health_app_2/data/models/water_model.dart';
import 'package:health_app_2/data/repositories/auth_repository.dart';
import 'package:health_app_2/data/repositories/health_repository.dart';

class MyProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final HealthRepository healthRepository;

  MyProvider({
    required this.authRepository,
    required this.healthRepository,
  });

  UserModel? userData;
  StepsModel? stepData;
  WaterModel? waterData;

  void init() {
    getUserProfile();
    getSteps();
    getWater();
    notifyListeners();
  }

  Future<bool> logout() async {
    return await authRepository.logout();
  }

  Future<void> getUserProfile() async {
    final result = await authRepository.getUserProfile();

    if (result.isRight()) {
      userData = result.right();
      di.set(userData!);
      notifyListeners();
    }

    if (result.isLeft() && result.left() == StatusType.expiredToken) {
      await authRepository.refreshToken();
      await authRepository.getUserProfile();

      getUserProfile();
    }
  }

  void getSteps() async {
    final result = await healthRepository.getSteps();

    if (result.isRight()) {
      final stepsModel = result.right();
      if (stepsModel.currentSteps != null && stepsModel.stepGoal != null && stepsModel.stepGoal != 0) {
        stepData = stepsModel;
      } else {
        stepData = null;
      }
      notifyListeners();
    }

    if (result.isLeft()) log(result.left().toString());
  }

  void getWater() async {
    final result = await healthRepository.getWaterIntake();

    print(result);

    if (result.isRight()) {
      final waterModel = result.right();
      if (waterModel.currentWater != null && waterModel.waterGoal != null && waterModel.waterGoal != 0) {
        waterData = waterModel;
      } else {
        waterData = null;
      }
      notifyListeners();
    }
  }
}
