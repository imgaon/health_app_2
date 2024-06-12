import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/presentation/component/colors.dart';
import 'package:health_app_2/presentation/component/dialog.dart';
import 'package:health_app_2/presentation/component/logo.dart';
import 'package:health_app_2/presentation/component/text_field.dart';
import 'package:health_app_2/presentation/providers/login_provider.dart';
import 'package:health_app_2/presentation/screens/register_screen.dart';
import 'package:health_app_2/presentation/screens/tab_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginProvider provider = di.get<LoginProvider>();

  void updateScreen() => setState(() {});

  @override
  void initState() {
    provider.username = TextEditingController();
    provider.password = TextEditingController();
    provider.addListener(updateScreen);
    super.initState();
  }

  @override
  void dispose() {
    provider.username.dispose();
    provider.password.dispose();
    provider.removeListener(updateScreen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              children: [
                logo(),
                const SizedBox(height: 50),
                textField(
                  context: context,
                  controller: provider.username,
                  hintText: 'username',
                  error: provider.usernameError,
                ),
                textField(
                  context: context,
                  controller: provider.password,
                  hintText: 'password',
                  error: provider.passwordError,
                  obscureText: true,
                ),
                loginButton(),
                const SizedBox(height: 20),
                registerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() => InkWell(
        onTap: () async {
          final result = await provider.login();

          if (provider.usernameError || provider.passwordError) return;

          if (result.statusCode == 200 && mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const TabScreen()),
              (route) => false,
            );
            return;
          }

          if (mounted) showAlertDialog(context: context, title: '로그인', result: result.message);
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
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );

  Widget registerButton() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Don\'t have an account?'),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen()),
            ),
            child: Text('register', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
          )
        ],
      );
}
