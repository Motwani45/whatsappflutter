import 'dart:io';

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