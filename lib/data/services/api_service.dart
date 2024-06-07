import 'dart:convert';

import 'package:health_app_2/data/models/response_model.dart';
import 'package:http/http.dart';

class ApiService {
  final Client client;

  ApiService({required this.client});

  Future<ResponseModel> get(Uri url, Map<String, String> headers) async {
    return await _sendRequest(() => client.get(url, headers: headers));
  }

  Future<ResponseModel> post(Uri url, Map<String, String> headers, String body) async {
    return await _sendRequest(() => client.post(url, headers: headers, body: body));
  }

  Future<ResponseModel> put(Uri url, Map<String, String> headers, String body) async {
    return await _sendRequest(() => client.put(url, headers: headers, body: body));
  }

  Future<ResponseModel> _sendRequest(Future<Response> Function() request) async {
    try {
      final response = await request();
      return ResponseModel(
        statusCode: response.statusCode,
        body: jsonDecode(response.body) as Map<String, dynamic>,
      );
    } catch (e) {
      return ResponseModel(
        statusCode: 500,
        body: {'error': e.toString()},
      );
    }
  }
}
