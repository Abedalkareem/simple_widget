import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AppButton({required this.text, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.black),
        textStyle:
            MaterialStateTextStyle.resolveWith((states) => const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )),
        padding: MaterialStateProperty.resolveWith((states) =>
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
