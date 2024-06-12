import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/core/utils/shared_preferences.dart';
import 'package:health_app_2/core/utils/status_type.dart';
import 'package:health_app_2/data/models/steps_model.dart';
import 'package:health_app_2/data/models/user_model.dart';
import 'package:health_app_2/data/models/water_model.dart';
import 'package:health_app_2/data/repositories/auth_repository.dart';
import 'package:health_app_2/data/repositories/health_repository.dart';

class EditProfileProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final HealthRepository healthRepository;

  EditProfileProvider({
    required this.authRepository,
    required this.healthRepository,
  });

  late UserModel userData;
  StepsModel? stepData;
  WaterModel? waterData;

  List<bool> gender = [false, false];
  late TextEditingController height;
  late TextEditingController weight;
  late TextEditingController targetValue;
  bool heightError = false;
  bool weightError = false;
  bool targetValueError = false;

  Future<bool> logout() async {
    return await authRepository.logout();
  }

  void init() {
    userData = di.get<UserModel>();

    height = TextEditingController();
    weight = TextEditingController();
    targetValue = TextEditingController();

    log(userData.height.toString());

    if (userData.gender == 'male' || userData.gender == '남자') {
      gender[0] = true;
    } else {
      gender[1] = true;
    }
  }

  Future<StatusType> editProfile() async {
    heightError =
        height.text.isEmpty ? false : !RegExp(r'^[0-9]+(\.[0-9]+)?$').hasMatch(height.text);
    weightError =
        weight.text.isEmpty ? false : !RegExp(r'^[0-9]+(\.[0-9]+)?$').hasMatch(weight.text);

    if (height.text.isEmpty && userData.height == null) return StatusType.missingHeightOrWeight;
    if (weight.text.isEmpty && userData.weight == null) return StatusType.missingHeightOrWeight;

    if (!heightError && !weightError) {
      final userInfo = {
        "gender": gender[0] ? '남자' : '여자',
        "height": height.text.isEmpty ? userData.height : double.parse(height.text),
        "weight": weight.text.isEmpty ? userData.weight : double.parse(weight.text),
      };

      final result = await authRepository.editProfile(userInfo);

      return result;
    }

    notifyListeners();
    return StatusType.internalSeverError;
  }

  Future<StatusType> editGoal(bool isWaterGoal) async {
    if (targetValue.text.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(targetValue.text)) {
      targetValueError = true;
    } else {
      targetValueError = false;
    }

    if (!targetValueError && isWaterGoal) {
      print('dfsdfsdf');
      final body = {'step_goal' : int.parse(targetValue.text)};

      final result = await healthRepository.setStepGoal(body);
      print(result);
      return StatusType.fromStatusCode(result.statusCode);
    } else if (!targetValueError && !isWaterGoal) {
      final body = {'water_goal' : int.parse(targetValue.text)};

      final result = await healthRepository.setWaterGoal(body);
      return StatusType.fromStatusCode(result.statusCode);
    }


    notifyListeners();
    return StatusType.internalSeverError;
  }

  void getSteps() async {
    final result = await healthRepository.getSteps();

    if (result.isRight()) {
      final stepsModel = result.right();
      if (stepsModel.currentSteps != null &&
          stepsModel.stepGoal != null &&
          stepsModel.stepGoal != 0) {
        stepData = stepsModel;
      } else {
        stepData = null;
      }
      notifyListeners();
    }

    if (result.isLeft()) log(result.left().toString());
  }

  void removeSteps() async {
    final goalBody = {"step_goal" : 0};
    final currentBody = {'current_steps' : 0};

    final goalResult = await healthRepository.setStepGoal(goalBody);
    final currentResult = await healthRepository.setCurrentSteps(currentBody);

    if (goalResult.statusCode == 200 && currentResult.statusCode == 200) {
      stepData = null;
      notifyListeners();
    }

    log('${goalResult.message} ${currentResult.message}');
  }

  void getWater() async {
    final result = await healthRepository.getWaterIntake();
    if (result.isRight()) {
      final waterModel = result.right();
      if (waterModel.currentWater != null && waterModel.waterGoal != null && waterModel.waterGoal != 0) {
        waterData = waterModel;
      } else {
        waterData = null;
      }
    }
    notifyListeners();
    return;
  }

  void removeWater() async {
    final currentBody = {'current_water_intake' : 0};
    final goalBody = {'water_goal' : 0};

    final goal = await healthRepository.setWaterGoal(goalBody);
    final current = await healthRepository.setWaterCurrent(currentBody);

    if (goal.statusCode == 200 && current.statusCode == 200) {
      notifyListeners();
    }
  }
}
