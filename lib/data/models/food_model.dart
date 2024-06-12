class FoodModel {
  final int calories;
  final String name;

  FoodModel({required this.calories, required this.name});

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        calories: json['calories'],
        name: json['name'],
      );
}
