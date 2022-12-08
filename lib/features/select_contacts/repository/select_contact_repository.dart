import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/models/user_model.dart';
import 'package:flutterwhatsappclone/features/chat/screens/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider((ref) {
  return SelectContactRepository(firestore: FirebaseFirestore.instance);
});

class SelectContactRepository {
  final FirebaseFirestore firestore;

  const SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }
  Future<List<Contact>> getRegisteredContacts() async{
    List<Contact> registeredContacts=[];
    List<Contact> contacts=await getContacts();
    var usersDataMap=await firestore.collection('users').get();
    for(int i=0;i<usersDataMap.docs.length;i++){
      UserModel model=UserModel.fromMap(usersDataMap.docs[i].data());
      for(var contact in contacts){
        String number=contact.phones[0].number.replaceAll(" ", '');
        if(number==model.phoneNumber){
          registeredContacts.add(contact);
        }
      }
    }
    return registeredContacts;
  }
  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      String selectedPhoneNumber =
          selectedContact.phones[0].number.replaceAll(' ', '');
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        if (selectedPhoneNumber == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.routeName,
              arguments: {"name": userData.name, "uid": userData.uid});
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context, content: "User is not registered in Whatsapp!!");
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
