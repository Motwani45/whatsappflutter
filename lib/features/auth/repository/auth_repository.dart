import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/repositories/common_firebase_storage_repository.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/features/auth/screens/otp_screen.dart';
import 'package:flutterwhatsappclone/features/auth/screens/user_information_screen.dart';
import 'package:flutterwhatsappclone/models/user_model.dart';
import 'package:flutterwhatsappclone/screens/mobile_layout_screen.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async{
    var userdata=await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if(userdata.data()!=null){
      user=UserModel.fromMap(userdata.data()!);
    }
    return user;
  }

  void signInWithPhone(
      {required BuildContext context, required String phoneNumber}) async {
    try {
      showLoaderDialog(context, "Sending OTP");
      await auth.verifyPhoneNumber(
          verificationCompleted: (credential) async {
            // dismissDialog(context);
            showLoaderDialog(context, "Verifying OTP");
            showSnackBar(context: context, content: "Phone Number Verified");
            await auth.signInWithCredential(credential);
            dismissDialog(context);
            Navigator.pushNamedAndRemoveUntil(
                context, UserInformationScreen.routeName, (route) => false);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: (verificationId, resendToken) async {
            dismissDialog(context);
            Navigator.pushNamed(context, OTPScreen.routeName,
                arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (verificationId) async {},
          phoneNumber: phoneNumber);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      dismissDialog(context);
      showSnackBar(context: context, content: "Phone Number Verified");
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      dismissDialog(context);
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png";
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase("profilePic/${uid}", profilePic);
      }

      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
  Stream<UserModel> userData(String userId){
    return firestore.collection("users").doc(userId).snapshots().map((event) => UserModel.fromMap(event.data()!));
  }
  void setUserState(bool isOnline) async{
    await firestore.collection('users').doc(auth.currentUser!.uid).update({'isOnline':isOnline});
  }
}
