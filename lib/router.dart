import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/common/widgets/error.dart';
import 'package:flutterwhatsappclone/features/auth/screens/login_screen.dart';
import 'package:flutterwhatsappclone/features/auth/screens/otp_screen.dart';
import 'package:flutterwhatsappclone/features/auth/screens/user_information_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
              ));
    case UserInformationScreen.routeName:
      // final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => UserInformationScreen());
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: "This Page Doesn\'t Exists"),
              ));
  }
}
