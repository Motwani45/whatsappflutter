
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/common/widgets/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../colors.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login_screen';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController=TextEditingController();

  Country? country;
  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
  void sendPhoneNumber(){
    String phoneNumber=phoneController.text.trim();
    if(country!=null&&phoneNumber.isNotEmpty){
      ref.read(authControllerProvider).signInWithPhone(context: context, phoneNumber: "+${country!.phoneCode}${phoneNumber}");
    }
    else if(country==null){
      showSnackBar(context: context, content: 'Please pick a Country by clicking "Pick Country" text');
    }
    else if(phoneNumber.isEmpty){
      showSnackBar(context: context, content: 'Please Enter Phone Number');
    }

  }
  void pickCountry(){

    showCountryPicker(context: context, onSelect: (_country){
      setState(() {
        country=_country;
      });
    },
    showPhoneCode:true);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: "Enter your phone number".text.make(),
        backgroundColor: backgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              "Whatsapp will need to verify your phone number".text.make(),
              10.heightBox,
              TextButton(onPressed: () {pickCountry();}, child: "Pick Country".text.make()),
              5.heightBox,
              Row(
                children: [
                  if(country!=null)
                    "+${country!.phoneCode}".text.make(),
                  10.widthBox,
                  SizedBox(
                    width: size.width*0.7,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: "phone number",

                      ),
                    ),
                  )
                ],
              )
            ],
          )
          ,
          SizedBox(
            width: 90,
            child: CustomButton(
              onPressed: (){
                sendPhoneNumber();
              },
              text: "NEXT",
            ),
          )

        ],
      ).p(18),
    );
  }
}
