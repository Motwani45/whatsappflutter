import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/features/status/controller/status_controller.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const String routeName="/confirm_status_screen";
  final File file;
  const ConfirmStatusScreen({required this.file,
    Key? key,
  }) : super(key: key);
  void addStatus(WidgetRef ref,BuildContext context){
    ref.read(statusControllerProvider).addStatus(statusImage: file, context: context);
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 9/16,
          child: Image.file(file),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed:(){addStatus(ref,context);} ,
        backgroundColor: tabColor,
        child: const Icon(Icons.done,color: Colors.white,),
      ),
    );
  }
}