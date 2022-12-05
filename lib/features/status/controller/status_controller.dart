import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:flutterwhatsappclone/features/status/repository/status_repository.dart';
import 'package:flutterwhatsappclone/models/status_model.dart';
final statusControllerProvider=Provider((ref) {
  var statusRepository=ref.watch(statusRepositoryProvider);
  return StatusController(statusRepository: statusRepository, ref: ref);
});
class StatusController{
  final StatusRepository statusRepository;
  final ProviderRef ref;

  const StatusController({
    required this.statusRepository,
    required this.ref,
  });
  void addStatus({
    required File statusImage,
    required BuildContext context,}){
    ref.watch(currentUserDataAuthProvider).whenData((value) {
    statusRepository.uploadStatus(
        username: value!.name,
        profilePic: value.profilePic,
        phoneNumber: value.phoneNumber,
        statusImage: statusImage,
        context: context);
    });
  }
  Future<List<Status>> getStatus(BuildContext context) async{
     return await statusRepository.getStatus(context);
  }

}