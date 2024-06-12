import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/status_type.dart';
import 'package:health_app_2/data/repositories/auth_repository.dart';

class RegisterProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  RegisterProvider({required this.authRepository});

  late TextEditingController username;
  late TextEditingController password;
  List<bool> gender = [true, false];

  bool usernameError = false;
  bool passwordError = false;
  bool genderError = false;

  Future<StatusType> register() async {
    usernameError = username.text.isEmpty;
    passwordError = password.text.isEmpty;

    if (!usernameError && !passwordError && !genderError) {
      final userData = {
        "username": username.text,
        "password": password.text,
        "gender": gender[0] ? '남자' : '여자',
      };

      final result = await authRepository.register(userData);

      return result;
    }

    notifyListeners();
    return StatusType.internalSeverError;
  }
}