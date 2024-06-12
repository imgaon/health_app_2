import 'dart:convert';

import 'package:health_app_2/data/models/user_model.dart';
import 'package:health_app_2/data/services/web_socket_service.dart';

class AlarmRepository {
  final WebSocketService webSocketService;

  AlarmRepository({required this.webSocketService});

  Stream<dynamic> get messages => webSocketService.message;

  Future<void> connect(UserModel user) async {
    await webSocketService.connect(user.id);
  }

  void disconnect() {
    webSocketService.disconnect();
  }
}