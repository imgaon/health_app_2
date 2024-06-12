import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/shared_preferences.dart';
import 'package:health_app_2/core/utils/status_type.dart';
import 'package:health_app_2/data/repositories/auth_repository.dart';

class LoginProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  LoginProvider({required this.authRepository});

  late TextEditingController username;
  late TextEditingController password;
  bool usernameError = false;
  bool passwordError = false;

  Future<StatusType> login() async {
    usernameError = username.text.isEmpty;
    passwordError = password.text.isEmpty;

    if (!usernameError && !passwordError) {
      final userData = {
        'username' : username.text,
        'password' : password.text,
      };

      final result = await authRepository.login(userData);
      if (result.statusCode == 200) Prefs.instance.prefs.setString('userData', jsonEncode(userData));

      return result;
    }

    notifyListeners();
    return StatusType.internalSeverError;
  }
}