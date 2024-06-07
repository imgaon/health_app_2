class ResponseModel {
  final int statusCode;
  final Map<String, dynamic> body;

  ResponseModel({required this.statusCode, required this.body});
}