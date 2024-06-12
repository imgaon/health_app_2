class StepsModel {
  int? currentSteps;
  final int? stepGoal;

  StepsModel({required this.currentSteps, required this.stepGoal});

  factory StepsModel.fromJson(Map<String, dynamic> json) => StepsModel(
        currentSteps: json['current_steps'],
        stepGoal: json['step_goal'],
      );

  Map<String, int> stepGoalToJson() => {
    'step_goal' : stepGoal!,
  };

  Map<String, int> currentStepsToJson() => {
    'current_steps' : currentSteps!,
  };
}
