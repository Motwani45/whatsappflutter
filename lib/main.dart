import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/common/widgets/error.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:flutterwhatsappclone/features/auth/screens/otp_screen.dart';
import 'package:flutterwhatsappclone/features/auth/screens/user_information_screen.dart';
import 'package:flutterwhatsappclone/features/landing/screens/landing_screen.dart';
import 'package:flutterwhatsappclone/router.dart';
import 'package:flutterwhatsappclone/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutterwhatsappclone/screens/mobile_layout_screen.dart';
import 'package:flutterwhatsappclone/screens/web_layout_screen.dart';
import 'package:flutterwhatsappclone/utils/responsive_layout.dart';

import 'common/widgets/loader.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor
        )
      ),
      onGenerateRoute: (settings)=>generateRoute(settings),
      home: ref.watch(currentUserDataAuthProvider).
      when(data:(user){
        if(user==null){
          print ("Landing");
          return const LandingScreen();
        }
        print ("Mobile");
        return const MobileLayoutScreen();
      }, error: (e,s){
        print ("Error");
          return ErrorScreen(error: e.toString());
      }, loading:(){
        print ("Loading");
       return  const Loader();
      })
    );
  }
}

