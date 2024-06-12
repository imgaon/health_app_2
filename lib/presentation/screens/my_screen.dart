import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/presentation/component/circular_graph.dart';
import 'package:health_app_2/presentation/component/colors.dart';
import 'package:health_app_2/presentation/providers/my_provider.dart';
import 'package:health_app_2/presentation/screens/edit_profile_screen.dart';
import 'package:health_app_2/presentation/screens/home_screen.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final MyProvider provider = di.get<MyProvider>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
    provider.getUserProfile();
    provider.getSteps();
    provider.getWater();
    provider.addListener(updateScreen);
    super.initState();
  }

  @override
  void dispose() {
    provider.removeListener(updateScreen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider.getUserProfile();
    provider.getSteps();
    // provider.getWater();


    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
            child: Column(
              children: [
                provider.userData == null ? CircularProgressIndicator() : profileWidget(),
                const SizedBox(height: 30),
                goalWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileWidget() => Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '나의 정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfileScreen()),
                  ),
                  child: const Icon(Icons.settings, size: 20),
                ),
              ],
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('유저이름 :',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(provider.userData!.username, style: const TextStyle(fontSize: 16))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('성별 :', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(provider.userData!.gender, style: const TextStyle(fontSize: 16))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('키 :', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(provider.userData!.height != null ? '${provider.userData!.height!.toString()}cm' : '아직 정보가 없습니다',
                    style: const TextStyle(fontSize: 16))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('몸무게 :', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(provider.userData!.weight != null ? '${provider.userData!.weight?.toString()}kg' : '아직 정보가 없습니다',
                    style: const TextStyle(fontSize: 16))
              ],
            ),
          ],
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
                  currentValue: isStepModel ? provider.stepData!.currentSteps! : provider.waterData!.currentWater!,
                  goalValue: isStepModel ? provider.stepData!.stepGoal! : provider.waterData!.waterGoal!,
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
}
