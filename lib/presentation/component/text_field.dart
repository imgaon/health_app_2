import 'package:flutter/material.dart';

Widget textField({
  required BuildContext context,
  required TextEditingController controller,
  required String hintText,
  bool error = false,
  String errorText = '필수 입력값입니다.',
  bool obscureText = false,
  Color backgroundColor = Colors.white,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: 50,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              hintText: hintText,
              fillColor: Colors.transparent,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            error ? errorText : '',
            style: const TextStyle(color: Colors.redAccent),
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
