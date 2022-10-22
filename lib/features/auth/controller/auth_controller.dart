import 'package:flutter/cupertino.dart';
import 'package:flutterwhatsappclone/features/auth/repository/auth_repository.dart';
import 'package:riverpod/riverpod.dart';
final authControllerProvider=Provider((ref) {
final authRepository=ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});
class AuthController{
  final AuthRepository authRepository;

  const AuthController({
    required this.authRepository,
  });
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
}