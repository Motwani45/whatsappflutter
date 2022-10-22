import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: tabColor,minimumSize: const Size(double.infinity,50)),
      child: text.text.color(blackColor).make(),
    );
  }
}
