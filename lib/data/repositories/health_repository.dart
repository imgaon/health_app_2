import 'dart:convert';
import 'dart:developer';

import 'package:health_app_2/core/utils/either.dart';
import 'package:health_app_2/core/utils/shared_preferences.dart';
import 'package:health_app_2/core/utils/status_type.dart';
import 'package:health_app_2/data/models/food_model.dart';
import 'package:health_app_2/data/models/steps_model.dart';
import 'package:health_app_2/data/models/water_model.dart';
import 'package:health_app_2/data/services/api_service.dart';
import 'package:http/http.dart';

class HealthRepository {
  final ApiService apiService;
  final Client client;

  HealthRepository({
    required this.apiService,
    required this.client,
  });

  final String _baseUrl = 'http://10.114.181.205:8082';

  Future<Either<StatusType, StepsModel>> getSteps() async {
    final String access = Prefs.instance.prefs.getString('access') ?? '';
    final Uri url = Uri.parse('$_baseUrl/health/steps');
    final headers = {'Authorization': 'Bearer $access'};

    final response = await apiService.get(url, headers);

    if (response.statusCode == 200) return Right(StepsModel.fromJson(response.body['body']));

    return Left(StatusType.fromStatusCode(response.statusCode));
  }

  Future<Either<StatusType, WaterModel>> getWaterIntake() async {
    final String access = Prefs.instance.prefs.getString('access') ?? '';
    final Uri url = Uri.parse('$_baseUrl/health/water');
    final headers = {'Authorization': 'Bearer $access'};

    final response = await apiService.get(url, headers);

    if (response.statusCode == 200) return Right(WaterModel.fromJson(response.body['body']));

    return Left(StatusType.fromStatusCode(response.statusCode));
  }

  Future<Either<StatusType, List<int>>> getHeartRate() async {
    final String access = Prefs.instance.prefs.getString('access') ?? '';
    final Uri url = Uri.parse('$_baseUrl/health/heart_rate');
    final headers = {'Authorization': 'Bearer $access'};

    final response = await apiService.get(url, headers);

    if (response.statusCode == 200) {
      final List<int> heartRateList = [];
      for (int data in response.body['body']['heart_rate_data']) {
        heartRateList.add(data);
      }
      return Right(heartRateList);
    }

    return Left(StatusType.fromStatusCode(response.statusCode));
  }

  Future<Either<StatusType, List<FoodModel>>> getFoodData() async {
    final String access = Prefs.instance.prefs.getString('access') ?? '';
    final Uri url = Uri.parse('$_baseUrl/health/food');
    final headers = {'Authorization': 'Bearer $access'};

    final response = await apiService.get(url, headers);

    if (response.statusCode == 200) {
      final List<FoodModel> foodList = [];
      for (Map<String, dynamic> json in response.body['body']['food_data']) {
        foodList.add(FoodModel.fromJson(json));
      }

      return Right(foodList);
    }

    return Left(StatusType.fromStatusCode(response.statusCode));
  }

  Future<StatusType> setStepGoal(Map<String, int?> data) async {
    final String access = Prefs.instance.prefs.getString('access') ?? '';
    final Uri url = Uri.parse('$_baseUrl/health/steps/goal');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    };
    final String body = jsonEncode(data);

    final response = await apiService.post(url, headers, body);

    return StatusType.fromStatusCode(response.statusCode);
  }

  Future<StatusType> setCurrentSteps(Map<String, int?> data) async {
    final String access = Prefs.instance.prefs.getString('access') ?? '';
    final Uri url = Uri.parse('$_baseUrl/health/steps/current');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    };
    final String body = jsonEncode(data);

    final response = await apiService.post(url, headers, body);

    return StatusType.fromStatusCode(response.statusCode);
  }

  Future<StatusType> setWaterGoal(Map<String, int?> data) async {
    final String access = Prefs.instance.prefs.getString('access') ?? '';
    final Uri url = Uri.parse('$_baseUrl/health/water/goal');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    };
    final String body = jsonEncode(data);

    final response = await apiService.post(url, headers, body);

    return StatusType.fromStatusCode(response.statusCode);
  }

  Future<StatusType> setWaterCurrent(Map<String, int?> data) async {
    final String access = Prefs.instance.prefs.getString('access') ?? '';
    final Uri url = Uri.parse('$_baseUrl/health/water/current');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $access',
    };
    final String body = jsonEncode(data);

    final response = await apiService.post(url, headers, body);

    return StatusType.fromStatusCode(response.statusCode);
  }
}
