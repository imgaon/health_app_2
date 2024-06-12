import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/presentation/component/colors.dart';
import 'package:health_app_2/presentation/providers/tab_provider.dart';
import 'package:health_app_2/presentation/screens/alarm_screen.dart';
import 'package:health_app_2/presentation/screens/home_screen.dart';
import 'package:health_app_2/presentation/screens/my_screen.dart';
import 'package:health_app_2/presentation/screens/workout_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final TabProvider provider = di.get<TabProvider>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
    provider.init();
    provider.addListener(updateScreen);
    super.initState();
  }

  @override
  void dispose() {
    provider.removeListener(updateScreen);
    super.dispose();
  }

  final List<Widget> screens = const [
    HomeScreen(),
    AlarmScreen(),
    WorkoutScreen(),
    MyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[provider.currentIndex],
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_filled),
        label: '홈',
      ),
      BottomNavigationBarItem(
        icon: SizedBox(
          width: 24,
          height: 24,
          child: Stack(
            children: [
              const Center(child: Icon(Icons.notifications)),
              provider.unreadNotifications
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        label: '알람',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.fitness_center),
        label: '워크아웃',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: '마이페이지',
      ),
    ];

    return BottomNavigationBar(
      items: items,
      currentIndex: provider.currentIndex,
      backgroundColor: background,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey,
      onTap: provider.tabChange,
    );
  }
}
