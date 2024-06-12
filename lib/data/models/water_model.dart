class WaterModel {
  final int? currentWater;
  final int? waterGoal;

  WaterModel({required this.currentWater, required this.waterGoal});

  factory WaterModel.fromJson(Map<String, dynamic> json) => WaterModel(
        currentWater: json['current_water_intake'],
        waterGoal: json['water_goal'],
      );

  Map<String, int?> waterGoalToJson() => {
    'water_goal' : waterGoal,
  };

  Map<String, int?> currentWaterToJson() => {
    'current_water_intake' : currentWater,
  };

  @override
  String toString() {
    return 'WaterModel{currentWater: $currentWater, waterGoal: $waterGoal}';
  }
}
