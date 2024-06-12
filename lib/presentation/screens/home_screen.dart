import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/data/models/steps_model.dart';
import 'package:health_app_2/data/models/user_model.dart';
import 'package:health_app_2/data/models/water_model.dart';
import 'package:health_app_2/presentation/component/arc_graph.dart';
import 'package:health_app_2/presentation/component/bar_graph.dart';
import 'package:health_app_2/presentation/component/bmi_graph.dart';
import 'package:health_app_2/presentation/component/circular_graph.dart';
import 'package:health_app_2/presentation/component/colors.dart';
import 'package:health_app_2/presentation/component/text_field.dart';
import 'package:health_app_2/presentation/providers/home_provider.dart';
import 'package:health_app_2/presentation/providers/tab_provider.dart';
import 'package:health_app_2/presentation/screens/edit_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeProvider provider = di.get<HomeProvider>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
    provider.init();
    provider.addListener(updateScreen);
    Future.delayed(const Duration(milliseconds: 300), () => provider.getSteps());
    super.initState();
  }

  @override
  void dispose() {
    provider.removeListener(updateScreen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title(),
              const SizedBox(height: 30),
              goalWidget(),
              const SizedBox(height: 30),
              waterWidget(),
              const SizedBox(height: 30),
              bmiWidget(),
              const SizedBox(height: 30),
              heartRateWidget(),
              const SizedBox(height: 30),
              foodWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget title() => Text(
        '반가워요, ${provider.userData?.username}님',
        style: const TextStyle(
          color: primary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget goalWidget() => SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: (provider.stepData == null && provider.waterData == null)
            ? Container()
            : Column(
                children: [
                  provider.stepData != null ? goalTile(true) : Container(),
                  provider.stepData != null ? const SizedBox(height: 20) : Container(),
                  provider.waterData != null ? goalTile(false) : Container(),
                ],
              ),
      );

  Widget goalTile(bool isStepModel) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isStepModel ? Colors.red.withOpacity(0.7) : Colors.blue.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isStepModel
                ? '걷기 목표 : ${provider.stepData!.currentSteps} / ${provider.stepData!.stepGoal}'
                : '물마시기 목표 ${provider.waterData!.currentWater} / ${provider.waterData!.waterGoal}',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(60, 60),
                painter: CircularGraph(
                  primaryColor: isStepModel ? primary : Colors.blueAccent,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  strokeWidth: 10,
                  currentValue: isStepModel
                      ? provider.stepData!.currentSteps!
                      : provider.waterData!.currentWater!,
                  goalValue:
                      isStepModel ? provider.stepData!.stepGoal! : provider.waterData!.waterGoal!,
                ),
              ),
              Text(
                isStepModel
                    ? (provider.stepData!.currentSteps! / provider.stepData!.stepGoal! * 100)
                        .floor()
                        .toString()
                    : (provider.waterData!.currentWater! / provider.waterData!.waterGoal! * 100)
                        .floor()
                        .toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget waterWidget() => Container(
        width: MediaQuery.sizeOf(context).width,
        height: 290,
        padding: const EdgeInsets.all(30),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ]),
        child: provider.waterData != null ? waterIndicator() : waterGoalSettingWidget(),
      );

  Widget waterGoalSettingWidget() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => editGoalDialog(),
            child: Container(
              width: 250,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  '물마시기 목표 설정하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      );

  Widget waterIndicator() => Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(250, 250),
            painter: ArchGraph(
              currentValue: provider.waterData!.currentWater!,
              targetValue: provider.waterData!.waterGoal!,
              strokeWidth: 15,
              rulerWidth: 0,
              backgroundColor: Colors.grey.shade200,
              primaryColor: Colors.blueAccent,
              rulerColor: Colors.transparent,
              startAngle: 180 * (pi / 180),
              sweepAngle: pi,
              useCenter: true,
              style: PaintingStyle.fill,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => provider.addAndRemoveWater(false),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Icon(Icons.remove, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: provider.setCurrentWater,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${provider.addWater}ml',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => provider.addAndRemoveWater(true),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Icon(Icons.add, color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ],
      );

  void editGoalDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          alignment: Alignment.center,
          title: const Text(
            '목표 수정',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 90,
            child: textField(
              context: context,
              controller: provider.targetValue,
              hintText: '목표',
              error: provider.targetValueError,
              backgroundColor: background,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            GestureDetector(
              onTap: () async {
                final result = await provider.editGoal();
                if (result.statusCode == 200 && mounted) {
                  Navigator.pop(context, true);
                }
              },
              child: Container(
                width: 180,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Center(
                  child: Text(
                    '수정하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
      );

  Widget bmiWidget() => Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: (provider.userData?.height != null && provider.userData?.weight != null)
            ? bmiIndicator()
            : missHeightOrWeight(),
      );

  Widget bmiIndicator() => Column(
        children: [
          CustomPaint(
            size: Size(MediaQuery.sizeOf(context).width, 50),
            painter:
                BmiGraph(height: provider.userData!.height!, weight: provider.userData!.weight!),
          ),
          const SizedBox(height: 10),
          Text(
            '회원님의 BMI지수는\n${(provider.userData!.weight! / pow((provider.userData!.height! / 100), 2)).toStringAsFixed(1)} (${provider.bmiToText(provider.userData!.weight! / pow((provider.userData!.height! / 100), 2))}) 입니다.',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
            textAlign: TextAlign.center,
          )
        ],
      );

  Widget missHeightOrWeight() => Center(
        child: Container(
          width: 350,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(60),
          ),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
            ),
            child: const Center(
              child: Text(
                '키,몸무게 입력하고 BMI측정하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );

  Widget heartRateWidget() => Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(20),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${provider.userData?.username}님의 24시간 평균 심박수예요.',
              style: const TextStyle(
                color: primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            CustomPaint(
              size: Size(MediaQuery.sizeOf(context).width, 80),
              painter: BarGraph(data: provider.heartRateList, maxValue: 150),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${provider.minHeartRate} ~ ${provider.maxHeartRate} ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'BPM',
                  style: TextStyle(
                    color: primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  '${provider.divHeartRate}',
                  style: const TextStyle(
                    color: primary,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.favorite, color: primary, size: 40)
              ],
            )
          ],
        ),
      );

  Widget foodWidget() => Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(20),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 200,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                itemCount: provider.foodDataList.length,
                itemBuilder: (context, index) => Container(
                  height: 200 / 3 - 10,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.foodDataList[index].name,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text('${provider.foodDataList[index].calories}cal'),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => const Divider(height: 10),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  '오늘 섭취 칼로리',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${provider.sumCalories}cal',
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      );
}
