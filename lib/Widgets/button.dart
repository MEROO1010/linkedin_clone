import 'package:flutter/material.dart';

class ButtonLogo extends StatelessWidget {
  final Icon icon;
  final String text;

  const ButtonLogo({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [icon, Text(text)],
    );
  }
}
