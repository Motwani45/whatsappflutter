import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

void showSnackBar({required BuildContext context,required String content}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content.text.make()));
}
 void showLoaderDialog(BuildContext context,String content){
  AlertDialog alert=AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(margin: const EdgeInsets.only(left: 7),child:Text(content)),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}
void dismissDialog(BuildContext context){
  Navigator.of(context).pop();
}
Future<GiphyGif?> pickGif(BuildContext context) async{
  GiphyGif? gif;
  try{
    // X98HIQQS3te38XxQmG9F2znhcN2gDpsl
    gif=await Giphy.getGif(context: context, apiKey: "X98HIQQS3te38XxQmG9F2znhcN2gDpsl");
  }
  catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return gif;
}
Future<File?> pickImageFromGallery(BuildContext context)async {
  File? image;
  try{
   final pickedImage=await ImagePicker().pickImage(source: ImageSource.gallery);
   if(pickedImage!=null){
     image=File(pickedImage.path);
   }
  }
  catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}
Future<File?> pickVideoFromGallery(BuildContext context)async {
  File? video;
  try{
   final pickedVideo=await ImagePicker().pickVideo(source: ImageSource.gallery);
   if(pickedVideo!=null){
     video=File(pickedVideo.path);
   }
  }
  catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}
