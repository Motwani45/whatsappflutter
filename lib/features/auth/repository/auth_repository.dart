import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/features/auth/screens/otp_screen.dart';
import 'package:flutterwhatsappclone/features/auth/screens/user_information_screen.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

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
}
