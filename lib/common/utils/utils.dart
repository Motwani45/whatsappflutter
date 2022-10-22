import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

void showSnackBar({required BuildContext context,required String content}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content.text.make()));
}