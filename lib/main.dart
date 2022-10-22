import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/features/auth/screens/otp_screen.dart';
import 'package:flutterwhatsappclone/features/landing/screens/landing_screen.dart';
import 'package:flutterwhatsappclone/router.dart';
import 'package:flutterwhatsappclone/screens/mobile_layout_screen.dart';
import 'package:flutterwhatsappclone/screens/web_layout_screen.dart';
import 'package:flutterwhatsappclone/utils/responsive_layout.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor
        )
      ),
      onGenerateRoute: (settings)=>generateRoute(settings),
      home: const LandingScreen()
    );
  }
}
