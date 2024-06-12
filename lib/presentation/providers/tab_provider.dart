import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/data/repositories/alarm_repository.dart';
import 'package:health_app_2/data/repositories/auth_repository.dart';

class TabProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final AlarmRepository alarmRepository;

  TabProvider({required this.authRepository, required this.alarmRepository});

  int currentIndex = 0;
  bool unreadNotifications = false;

  Future<void> init() async {
    final userData = await authRepository.getUserProfile();
    if (userData.isRight()) {
      di.set(userData.isRight());
      await alarmRepository.connect(userData.right());
    }
  }

  void notification() {
    if (currentIndex != 1) unreadNotifications = true;
    notifyListeners();
  }

  void readNotification() {
    if (currentIndex == 1) unreadNotifications = false;
    notifyListeners();
  }

  void tabChange(int index) {
    if (index != currentIndex) currentIndex = index;
    readNotification();
  }

}