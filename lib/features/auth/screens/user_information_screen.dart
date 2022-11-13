import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = "/user_information";

  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  File? image;
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
void selectImage() async{
image=await pickImageFromGallery(context);
setState(() {
});
}
void storeUserData() async{
    String name=nameController.text.trim();
    if(name.isNotEmpty){
      ref.read(authControllerProvider).saveUserDataToFirebase(name: name, profilePic: image, context: context);
    }
}
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                (image==null)?
                CircleAvatar(
                  radius: 64,
                  backgroundImage: Image.network(
                          "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png")
                      .image,
                ):CircleAvatar(
                  radius: 64,
                  backgroundImage: FileImage(image!),
                ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed:selectImage
                        , icon: const Icon(Icons.add_a_photo)))
              ],
            ),
            Row(
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Name",
                    ),
                  ),
                ),
                IconButton(onPressed:storeUserData, icon: const Icon(Icons.done)),
              ],
            )
          ],
        ),
      )),
    );
  }
}
