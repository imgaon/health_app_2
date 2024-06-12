import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/presentation/component/arc_graph.dart';
import 'package:health_app_2/presentation/component/colors.dart';
import 'package:health_app_2/presentation/component/text_field.dart';
import 'package:health_app_2/presentation/providers/workout_provider.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final WorkoutProvider provider = di.get<WorkoutProvider>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
    provider.getStepsData();
    provider.targetValue = TextEditingController();
    provider.addListener(updateScreen);
    super.initState();
  }

  @override
  void dispose() {
    provider.targetValue.dispose();
    provider.removeListener(updateScreen);
    provider.setCurrentSteps();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
          child: provider.noWalkingGoal ? goalSettingWidget() : walkingWidget(),
        ),
      ),
    );
  }

  Widget goalSettingWidget() => Container(
        width: MediaQuery.sizeOf(context).width,
        height: 260,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              '걷기운동 목표 설정하기',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            textField(
                context: context,
                controller: provider.targetValue,
                hintText: '목표 걸음 수',
                error: provider.targetValueError,
                backgroundColor: background),
            setStepGoalButton(),
          ],
        ),
      );

  Widget setStepGoalButton() => GestureDetector(
        onTap: () async {
          final result = await provider.setStepGoal();

          if (result.statusCode == 200) provider.getStepsData();
        },
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 50,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              '설정하기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

  Widget walkingWidget() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: ArchGraph(
                    currentValue: provider.stepsData!.currentSteps!,
                    targetValue: provider.stepsData!.stepGoal!,
                    strokeWidth: 25,
                    rulerWidth: 5,
                    backgroundColor: Colors.grey.shade300,
                    primaryColor: primary,
                    rulerColor: Colors.grey,
                    startAngle: 135 * (pi / 180),
                    sweepAngle: 270 * (pi / 180),
                    useCenter: false,
                    style: PaintingStyle.stroke,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.directions_run_rounded, size: 50, color: primary),
                    Text(
                      '${provider.stepsData!.currentSteps! < provider.stepsData!.stepGoal! ? (provider.stepsData!.currentSteps! / provider.stepsData!.stepGoal! * 100).floor() : 100}%',
                      style: const TextStyle(
                        color: primary,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${provider.stepsData!.currentSteps!} / ${provider.stepsData!.stepGoal!}',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    )
                  ],
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () async {
              if (provider.pauseWalking) {
                provider.pauseWalking = false;
                provider.startListening();
                updateScreen();
              } else {
                final result = await provider.setCurrentSteps();
                if (result.statusCode == 200) provider.pauseWalking = true;
                provider.stopListening();
                updateScreen();
              }
            },
            child: Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  (provider.pauseWalking) ? '다시시작' : '일시정지',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
