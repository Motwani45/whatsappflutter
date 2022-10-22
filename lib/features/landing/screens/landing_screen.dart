import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/widgets/custom_button.dart';
import 'package:flutterwhatsappclone/features/auth/screens/login_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            40.heightBox,
            "Welcome To Whatsapp"
                .text
                .size(33)
                .fontWeight(FontWeight.w600)
                .make(),
            (size.height / 12).heightBox,
            Image.asset(
              "assets/bg.png",
              color: tabColor,
            ).wFourFifth(context),
            (size.height / 10).heightBox,
            "Read our Privacy Policy. Tap \"Agree and Continue\" to accept the Terms of Service. "
                .text
                .align(TextAlign.center)
                .color(greyColor)
                .make()
                .p(15),
            10.heightBox,
            SizedBox(
              width: size.width * 0.75,
              child: CustomButton(
                text: "AGREE AND CONTINUE",
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                },
              ),
            ),
            20.heightBox,
          ],
        ),
      ),
    );
  }
}
