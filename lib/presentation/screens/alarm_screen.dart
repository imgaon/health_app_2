import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/presentation/component/colors.dart';
import 'package:health_app_2/presentation/providers/alarm_provider.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final AlarmProvider provider = di.get<AlarmProvider>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
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
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('알림', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: provider.toggleAlarm,
                    child: provider.allowAlarm
                        ? const Icon(Icons.notifications_active)
                        : const Icon(Icons.notifications_none),
                  )
                ],
              ),
              const Divider(height: 30),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => notifyWidget(index),
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemCount: provider.notifications.length,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget notifyWidget(int index) => Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: provider.notifications[index].key == "notify"
              ? Colors.blueAccent.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              provider.notifications[index].value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: () => provider.removeNotification(index),
              child: const Icon(Icons.close),
            )
          ],
        ),
      );
}
