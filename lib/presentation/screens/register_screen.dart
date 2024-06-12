import 'package:flutter/material.dart';
import 'package:health_app_2/core/utils/dependency_injection.dart';
import 'package:health_app_2/presentation/component/colors.dart';
import 'package:health_app_2/presentation/component/dialog.dart';
import 'package:health_app_2/presentation/component/logo.dart';
import 'package:health_app_2/presentation/component/text_field.dart';
import 'package:health_app_2/presentation/providers/register_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterProvider provider = di.get<RegisterProvider>();

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
      appBar: AppBar(
        backgroundColor: background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
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
                    error: provider.usernameError,
                    obscureText: true),
                ToggleButtons(
                  constraints: BoxConstraints(
                      minHeight: 30, minWidth: MediaQuery.sizeOf(context).width / 2 - 60),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  borderRadius: BorderRadius.circular(30),
                  fillColor: primary,
                  selectedColor: Colors.white,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < provider.gender.length; i++) {
                        provider.gender[i] = i == index;
                      }
                    });
                  },
                  isSelected: provider.gender,
                  children: const [
                    Text('남성'),
                    Text('여성'),
                  ],
                ),
                const SizedBox(height: 30),
                registerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerButton() => InkWell(
        onTap: () async {
          final result = await provider.register();

          if (provider.usernameError || provider.passwordError) return;

          if (mounted) {
            showAlertDialog(
              context: context,
              title: '회원가입',
              result: result.message,
              doublePop: result.statusCode == 201 ? true : false,
            );
          }
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
              'Register',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
}
