import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutterwhatsappclone/features/auth/repository/auth_repository.dart';
import 'package:flutterwhatsappclone/models/group_model.dart';
import 'package:flutterwhatsappclone/models/message.dart';
import 'package:riverpod/riverpod.dart';

import '../../../models/user_model.dart';
final authControllerProvider=Provider((ref) {
final authRepository=ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository,ref: ref);
});
final currentUserDataAuthProvider=FutureProvider((ref) {
  final authController=ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
});
final userDataAuthProvider=FutureProvider.family<UserModel?,String>((ref, userId) {
  final authController=ref.watch(authControllerProvider);
  return authController.getUserData(userId: userId);
});
class AuthController{
  final AuthRepository authRepository;
  final ProviderRef ref;

  const AuthController({
    required this.authRepository,
    required this.ref
  });
  Future<UserModel?> getCurrentUserData() async{
    return authRepository.getCurrentUserData();
  }
  Future<UserModel?> getUserData({
  required String userId
}) async{
    return authRepository.getUserData(userId);
  }
  void signInWithPhone(
      {required BuildContext context, required String phoneNumber}) async{
    authRepository.signInWithPhone(context: context, phoneNumber: phoneNumber);
  }
  void verifyOTP(
      {required BuildContext context,
        required String verificationId,
        required String userOTP}) async{
    authRepository.verifyOTP(context: context, verificationId: verificationId, userOTP: userOTP);
  }
  void saveUserDataToFirebase(
      {required String name,
        required File? profilePic,
        required BuildContext context}){
    authRepository.saveUserDataToFirebase(name: name, profilePic: profilePic, ref: ref, context: context);
  }
  Stream<UserModel> userDataById(String userId){
    return authRepository.userData(userId);
  }
  Stream<GroupModel> groupDataById(String userId){
    return authRepository.groupData(userId);
  }
  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }

}