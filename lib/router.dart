import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/common/widgets/error.dart';
import 'package:flutterwhatsappclone/features/auth/screens/login_screen.dart';
import 'package:flutterwhatsappclone/features/auth/screens/otp_screen.dart';
import 'package:flutterwhatsappclone/features/auth/screens/user_information_screen.dart';
import 'package:flutterwhatsappclone/features/select_contacts/screens/select_contact_screen.dart';
import 'package:flutterwhatsappclone/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutterwhatsappclone/features/status/screens/confirm_status_screen.dart';
import 'package:flutterwhatsappclone/features/status/screens/status_screen.dart';
import 'package:flutterwhatsappclone/models/status_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());
    case MobileChatScreen.routeName:
      final arguments=settings.arguments as Map<String,dynamic>;
      final name=arguments['name'];
      final uid=arguments["uid"];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(name:name,uid:uid));
      case ConfirmStatusScreen.routeName:
      final file=settings.arguments as File;
      return MaterialPageRoute(
          builder: (context) => ConfirmStatusScreen(file: file,));
      case StatusScreen.routeName:
      final status=settings.arguments as Status;
      return MaterialPageRoute(
          builder: (context) => StatusScreen(status: status,));
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
              ));
    case UserInformationScreen.routeName:
      // final verificationId = settings.arguments as String;
      return MaterialPageRoute(builder: (context) => const UserInformationScreen());
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: "This Page Doesn\'t Exists"),
              ));
  }
}
