import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/repositories/common_firebase_storage_repository.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/models/group_model.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider((ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  const GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContacts) async {
    try {
      List<String> uids = [];
      for (var userContact in selectedContacts) {
        var userData = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: userContact.phones[0].number.replaceAll(" ", ""))
            .get();
        uids.add(userData.docs[0].data()['uid']);
      }
      var groupId = const Uuid().v1();
      String profilePicUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase("group/$groupId", profilePic);
      GroupModel group = GroupModel(
          name: name,
          groupId: groupId,
          lastMessage: "",
          membersUid: [auth.currentUser!.uid, ...uids],
          groupPic: profilePicUrl,
          senderId: auth.currentUser!.uid,
      timeSent: DateTime.now());

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
