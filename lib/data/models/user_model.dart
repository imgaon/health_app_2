class UserModel {
  final int id;
  final String username;
  final String gender;
  final double? height;
  final double? weight;

  UserModel({
    required this.id,
    required this.username,
    required this.gender,
    required this.height,
    required this.weight,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        username: json['username'],
        gender: json['gender'],
        height: json['height'],
        weight: json['weight'],
      );
}
