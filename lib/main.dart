import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/core/utils/shared_preferences.dart';
import 'package:health_app_2/data/repositories/alarm_repository.dart';
import 'package:health_app_2/data/repositories/auth_repository.dart';
import 'package:health_app_2/data/repositories/health_repository.dart';
import 'package:health_app_2/data/services/api_service.dart';
import 'package:health_app_2/data/services/web_socket_service.dart';
import 'package:health_app_2/presentation/providers/alarm_provider.dart';
import 'package:health_app_2/presentation/providers/edit_profile_provider.dart';
import 'package:health_app_2/presentation/providers/home_provider.dart';
import 'package:health_app_2/presentation/providers/login_provider.dart';
import 'package:health_app_2/presentation/providers/my_provider.dart';
import 'package:health_app_2/presentation/providers/register_provider.dart';
import 'package:health_app_2/presentation/providers/splash_provider.dart';
import 'package:health_app_2/presentation/providers/tab_provider.dart';
import 'package:health_app_2/presentation/providers/workout_provider.dart';
import 'package:health_app_2/presentation/screens/splash_screen.dart';
import 'package:health_app_2/presentation/screens/workout_screen.dart';
import 'package:http/http.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Prefs.instance.init();

  final Client client = Client();

  final ApiService apiService = ApiService(client: client);
  final WebSocketService webSocketService = WebSocketService();

  final AuthRepository authRepository = AuthRepository(apiService: apiService);
  final AlarmRepository alarmRepository = AlarmRepository(webSocketService: webSocketService);
  final HealthRepository healthRepository = HealthRepository(apiService: apiService, client: client);

  final SplashProvider splashProvider = SplashProvider(authRepository: authRepository);
  final LoginProvider loginProvider = LoginProvider(authRepository: authRepository);
  final RegisterProvider registerProvider = RegisterProvider(authRepository: authRepository);
  final EditProfileProvider editProfileProvider = EditProfileProvider(authRepository: authRepository, healthRepository: healthRepository);
  final MyProvider myProvider = MyProvider(authRepository: authRepository, healthRepository: healthRepository);
  final TabProvider tabProvider = TabProvider(authRepository: authRepository, alarmRepository: alarmRepository);
  final AlarmProvider alarmProvider = AlarmProvider(alarmRepository: alarmRepository, tabProvider: tabProvider);
  final HomeProvider homeProvider = HomeProvider(healthRepository: healthRepository, authRepository: authRepository);
  final WorkoutProvider workOutProvider = WorkoutProvider(healthRepository: healthRepository);

  di.set(splashProvider);
  di.set(loginProvider);
  di.set(registerProvider);
  di.set(editProfileProvider);
  di.set(myProvider);
  di.set(alarmProvider);
  di.set(tabProvider);
  di.set(homeProvider);
  di.set(workOutProvider);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    )
  );
}