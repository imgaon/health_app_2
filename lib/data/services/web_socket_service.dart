import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:health_app_2/core/utils/shared_preferences.dart';
import 'package:http/http.dart';

class WebSocketService {
  WebSocket? _socket;
  final StreamController<dynamic> _streamController = StreamController<dynamic>();

  Stream<dynamic> get message => _streamController.stream;

  Future<void> connect(int userId) async {
    final String access = Prefs.instance.prefs.getString('access') ?? '';

    try {
      // 웹 소켓 연결
      _socket = await WebSocket.connect('ws://10.114.181.205:8765/$access');
      log('Connected to WebSocket server');

      // 조인
      final joinMessage = jsonEncode({
        'event': 'join',
        'data': {'room_id': userId}
      });
      _socket?.add(joinMessage);
      log('Sent join message: $joinMessage');

      // 메시지 수신
      _socket?.listen((data) {
        final message = jsonDecode(data);
        log('Received message: $message');
        _streamController.add(message);
      }, onDone: () {
        log('Disconnected from WebSocket server');
      }, onError: (error) {
        log('WebSocket error: $error');
      });

      // ping/pong
      Timer.periodic(const Duration(seconds: 10), (timer) {
        _socket?.add(jsonEncode({'event': 'ping'}));
      });
    } catch (e) {
      log('WebSocket connection error: $e');
    }
  }

  void disconnect() {
    _socket?.close();
  }
}
