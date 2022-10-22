import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../colors.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = "/otp_screen";
  final String verificationId;

  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);
void verifyOTP(BuildContext context,String userOTP,WidgetRef ref){
  ref.read(authControllerProvider).verifyOTP(context: context, verificationId: verificationId, userOTP: userOTP);
}
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: "Verify your number".text.make(),
          backgroundColor: backgroundColor,
        ),
        body: Center(
          child: Column(
            children: [
              "We have sent an SMS with a code".text.make(),
              SizedBox(
                width: (size.width*0.5),
                child: TextField(
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (val){
                    if(val.length==6){
                      showLoaderDialog(context, "Verifying OTP");
                      verifyOTP(context, val.trim(), ref);
                    }
                  },
                  style: const TextStyle(
                    fontSize: 30
                  ),
                  decoration: const InputDecoration(
                    hintText: "- - - - - -",
                    hintStyle: TextStyle(fontSize: 40),


                  ),
                ),
              )
            ],
          ).pSymmetric(v: 20),
        )
    );
  }
}
