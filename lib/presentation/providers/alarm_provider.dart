import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/data/models/notify_model.dart';
import 'package:health_app_2/data/repositories/alarm_repository.dart';
import 'package:health_app_2/presentation/providers/tab_provider.dart';

class AlarmProvider extends ChangeNotifier {
  final AlarmRepository alarmRepository;
  final TabProvider tabProvider;

  AlarmProvider({required this.alarmRepository, required this.tabProvider}) {connect();}

  List<NotifyModel> notifications = [];
  bool allowAlarm = true;

  void connect() {
    alarmRepository.messages.listen((message) {
      final Map<String, dynamic> a = message['message'];
      final data = a.map((key, value) => MapEntry(key.toString(), value.toString()));
      notifications.add(NotifyModel.mapToNotifyModel(data));
      if (allowAlarm) tabProvider.notification();
      notifyListeners();
    });
  }

  void toggleAlarm() {
    allowAlarm = !allowAlarm;
    notifyListeners();
  }

  void removeNotification(int index) {
    notifications.removeAt(index);
    notifyListeners();
  }
}