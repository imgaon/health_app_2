import 'dart:convert';
import 'dart:developer';

import 'package:health_app_2/core/utils/either.dart';
import 'package:health_app_2/core/utils/shared_preferences.dart';
import 'package:health_app_2/core/utils/status_type.dart';
import 'package:health_app_2/data/models/user_model.dart';
import 'package:health_app_2/data/services/api_service.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository({required this.apiService});

  final String _baseUrl = 'http://10.114.181.205:8082';

  Future<StatusType> login(Map<String, String> userData) async {
    final Uri url = Uri.parse('$_baseUrl/auth/login');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final String body = jsonEncode(userData);

    final response = await apiService.post(url, headers, body);

    if (response.statusCode == 200) {
      final String access = response.body['body']['access_token'];
      final String refresh = response.body['body']['refresh_token'];
      Prefs.instance.prefs.setString('access', access);
      Prefs.instance.prefs.setString('refresh', refresh);
    }

    if (response.statusCode == 401) return StatusType.unauthorized;

    return StatusType.fromStatusCode(response.statusCode);
  }

  Future<StatusType> register(Map<String, String> userData) async {
    final Uri url = Uri.parse('$_baseUrl/auth/register');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final String body = jsonEncode(userData);

    final response = await apiService.post(url, headers, body);

    return StatusType.fromStatusCode(response.statusCode);
  }

  Future<bool> logout() async {
    final result = await Future.wait([
      Prefs.instance.prefs.remove('access'),
      Prefs.instance.prefs.remove('refresh'),
      Prefs.instance.prefs.remove('userData'),
    ]);

    return result.every((element) => element == true);
  }

  Future<StatusType> refreshToken() async {
    final Uri url = Uri.parse('$_baseUrl/auth/refresh');
    final String refresh = Prefs.instance.prefs.getString('refresh') ?? '';
    final Map<String, String> headers = {
      'Authorization' : 'Bearer $refresh',
      'Content-Type': 'application/json',
    };

    final response = await apiService.post(url, headers, null);

    if (response.statusCode == 200) {
      final String access = response.body['body']['access_token'];
      final String refresh = response.body['body']['refresh_token'];
      Prefs.instance.prefs.setString('access', access);
      Prefs.instance.prefs.setString('refresh', refresh);
    }

    return StatusType.fromStatusCode(response.statusCode);
  }

  Future<StatusType> editProfile(Map<String, dynamic> userData) async {
    final String access = Prefs.instance.prefs.getString('access') ?? '';
    final Uri url = Uri.parse('$_baseUrl/user/update');
    final Map<String, String> headers = {
      'Authorization': 'Bearer $access',
      'Content-Type': 'application/json',
    };
    final String body = jsonEncode(userData);

    final response = await apiService.post(url, headers, body);

    return StatusType.fromStatusCode(response.statusCode);
  }

  Future<Either<StatusType, UserModel>> getUserProfile() async {
    final String access = Prefs.instance.prefs.getString('access') ?? '';
    final Uri url = Uri.parse('$_baseUrl/user/info');
    final headers = {
      'Authorization': 'Bearer $access',
      'Content-Type': 'application/json',
    };

    final response = await apiService.get(url, headers);

    if (response.statusCode == 200) return Right(UserModel.fromJson(response.body['body']));

    final statusType = StatusType.fromStatusCode(response.statusCode);
    return Left(statusType);
  }
}
