import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app_2/core/utils/status_type.dart';
import 'package:health_app_2/data/models/steps_model.dart';
import 'package:health_app_2/data/repositories/health_repository.dart';

class WorkoutProvider extends ChangeNotifier {
  final HealthRepository healthRepository;

  WorkoutProvider({required this.healthRepository});

  final _sensorChannel = const EventChannel('sensor');
  final double _threshold = 40;
  List<double> _previousEvent = [0, 0, 0];
  StreamSubscription? _subscription;
  StepsModel? stepsData;

  late TextEditingController targetValue;
  bool targetValueError = false;
  bool noWalkingGoal = true;
  bool pauseWalking = false;

  Future<void> getStepsData() async {
    final result = await healthRepository.getSteps();

    if (result.isRight()) {
      final stepsModel = result.right();
      if (stepsModel.stepGoal != null &&
          stepsModel.currentSteps != null &&
          stepsModel.stepGoal != 0) {
        stepsData = stepsModel;
        noWalkingGoal = false;
      } else {
        stepsData = null;
        noWalkingGoal = true;
        stopListening();
      }
      notifyListeners();
    }

    if (result.isLeft()) log(result.left().toString());
  }

  Future<StatusType> setStepGoal() async {
    if (!RegExp(r'^[0-9]+$').hasMatch(targetValue.text) ||
        targetValue.text.isEmpty ||
        int.parse(targetValue.text) <= 0) {
      targetValueError = true;
      return StatusType.missingTarget;
    }

    final goalBody = {"step_goal": int.parse(targetValue.text)};
    final currentBody = {"current_steps": 0};

    final goalResult = await healthRepository.setStepGoal(goalBody);
    final currentResult = await healthRepository.setCurrentSteps(currentBody);

    log(goalResult.message);
    log(currentResult.message);

    if (currentResult.statusCode == 200) {
      if (goalResult.statusCode == 200) {
        noWalkingGoal = false;
        startListening();
      }

      return StatusType.fromStatusCode(goalResult.statusCode);
    }

    notifyListeners();
    return StatusType.internalSeverError;
  }

  Future<StatusType> setCurrentSteps() async {
    if (stepsData != null) {
      final body = {'current_steps': stepsData!.currentSteps!};

      final result = await healthRepository.setCurrentSteps(body);

      return StatusType.fromStatusCode(result.statusCode);
    }

    return StatusType.internalSeverError;
  }

  void startListening() {
    _subscription = _sensorChannel.receiveBroadcastStream().listen((event) {
      List<double> sensorValues = List<double>.from(event);
      double x = sensorValues[0] - _previousEvent[0];
      double y = sensorValues[1] - _previousEvent[1];
      double z = sensorValues[2] - _previousEvent[2];

      double magnitude = (x * x) + (y * y) + (z * z);
      if (magnitude > _threshold && stepsData!.currentSteps != null) {
        stepsData!.currentSteps = (stepsData!.currentSteps! + 1);
        notifyListeners();
      }
      _previousEvent = sensorValues;
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }
}
