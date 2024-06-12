import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/presentation/component/colors.dart';
import 'package:health_app_2/presentation/component/dialog.dart';
import 'package:health_app_2/presentation/component/text_field.dart';
import 'package:health_app_2/presentation/providers/edit_profile_provider.dart';
import 'package:health_app_2/presentation/screens/login_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileProvider provider = di.get<EditProfileProvider>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
    provider.init();
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
    provider.getSteps();
    provider.getWater();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: const Text('프로필 관리'),
          backgroundColor: background,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              children: [
                editProfileWidget(),
                const SizedBox(height: 30),
                goalWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editProfileWidget() => Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(30),
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
          )
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('정보 수정', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                     final result = await provider.logout();

                     if (result && mounted) {
                       Navigator.pushAndRemoveUntil(
                         context,
                         MaterialPageRoute(builder: (context) => const LoginScreen()),
                         (route) => false,
                       );
                     }
                    },
                    child: const Center(
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Divider(height: 35),
            ToggleButtons(
              constraints: BoxConstraints(
                minHeight: 30,
                minWidth: MediaQuery.sizeOf(context).width / 2 - 65,
              ),
              borderRadius: BorderRadius.circular(30),
              fillColor: primary,
              selectedColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              onPressed: (int index) {
                for (int i = 0; i < provider.gender.length; i++) {
                  setState(() {
                    provider.gender[i] = i == index;
                  });
                }
              },
              isSelected: provider.gender,
              children: const [
                Text('남자'),
                Text('여자'),
              ],
            ),
            const SizedBox(height: 30),
            textField(
              context: context,
              controller: provider.height,
              hintText: provider.userData.height?.toString() ?? '키',
              backgroundColor: background,
            ),
            textField(
              context: context,
              controller: provider.weight,
              hintText: provider.userData.weight?.toString() ?? '몸무게',
              backgroundColor: background,
            ),
            editButton(),
          ],
        ),
      );

  Widget editButton() => GestureDetector(
        onTap: () async {
          final result = await provider.editProfile();

          if (provider.weightError || provider.heightError) return;

          if (mounted) showAlertDialog(context: context, title: '정보수정', result: result.message);
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
              '수정하기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  editGoalDialog(isStepModel);
                },
                child: const Icon(Icons.edit_rounded, color: Colors.white),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: isStepModel ? provider.removeSteps : provider.removeWater,
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void editGoalDialog(bool isStepModel) => showDialog(
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
                final result = await provider.editGoal(isStepModel ? true : false);
                if (result.statusCode == 200 && mounted) {
                  Navigator.pop(context, true);
                }
              },
              child: Container(
                width: 180,
                height: 40,
                decoration: BoxDecoration(
                  color: primary,
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
}
