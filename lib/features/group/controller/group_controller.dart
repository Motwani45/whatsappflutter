import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/features/group/repository/group_repositroy.dart';
final groupControllerProvider=Provider((ref){
  GroupRepository repository=ref.watch(groupRepositoryProvider);
  return GroupController(repository: repository, ref: ref);
});
class GroupController{
  final GroupRepository repository;
  final ProviderRef ref;

  const GroupController({
    required this.repository,
    required this.ref,
  });
  void createGroup(
      BuildContext context,
      String name,
      File profilePic,
      List<Contact> selectedContacts
      ){
    repository.createGroup(context, name, profilePic, selectedContacts);
  }
}