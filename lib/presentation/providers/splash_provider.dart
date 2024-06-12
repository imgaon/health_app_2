import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/core/utils/shared_preferences.dart';
import 'package:health_app_2/data/repositories/alarm_repository.dart';
import 'package:health_app_2/data/repositories/auth_repository.dart';

class SplashProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  SplashProvider({
    required this.authRepository,
  });

  bool isLoginUser = false;

  void checkLoginUser() async {
    final access = Prefs.instance.prefs.getString('access') ?? '';
    if (access.isNotEmpty) {
      await authRepository.refreshToken();
      isLoginUser = true;
    }
  }
}
