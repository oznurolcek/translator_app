import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() press;
  final String text;
  final Color color;

  const Button({
    Key? key,
    required this.press,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(text),
    );
  }
}
