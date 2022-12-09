import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
import 'package:flutterwhatsappclone/common/providers/message_reply_provider.dart';
import 'package:flutterwhatsappclone/common/repositories/common_firebase_storage_repository.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:flutterwhatsappclone/models/chat_contact.dart';
import 'package:flutterwhatsappclone/models/group_model.dart';
import 'package:flutterwhatsappclone/models/message.dart';
import 'package:flutterwhatsappclone/models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
});

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void sendTextMessage({required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUserData,
  required MessageReply? messageReply,
  required bool isGroupChat}) async {
    try {
      var timeSent = DateTime.now();
        UserModel? receiverUserData;
      if(!isGroupChat) {
        var userDataMap =
        await firestore.collection('users').doc(receiverUserId).get();
        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }
      var messageId = const Uuid().v1();

      _saveDataToContactSubcollection(
          timeSent: timeSent,
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          receiverUserId: receiverUserId,
          text: text,
      isGroupChat:isGroupChat);
      _saveMessageToMessageSubcollection(
          receiverUserId: receiverUserId,
          text: text,
          timeSent: timeSent,
          receiverUsername: receiverUserData?.name,
          senderUsername: senderUserData.name,
          messageType: MessageEnum.text,
          messageId: messageId,
          messageReply: messageReply,
      isGroupChat:isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void _saveDataToContactSubcollection({required UserModel senderUserData,
    required UserModel? receiverUserData,
    required String text,
    required DateTime timeSent,
    required String receiverUserId,
  required bool isGroupChat}) async {
if(isGroupChat){
  await firestore.collection('groups').doc(receiverUserId).update({
    'lastMessage':text,
    'timeSent':DateTime.now()
  });
}
else {
  var receiverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text);
  await firestore
      .collection('users')
      .doc(receiverUserId)
      .collection('chats')
      .doc(senderUserData.uid)
      .set(receiverChatContact.toMap());
  var senderChatContact = ChatContact(
      name: receiverUserData!.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text);
  await firestore
      .collection('users')
      .doc(senderUserData.uid)
      .collection('chats')
      .doc(receiverUserData.uid)
      .set(senderChatContact.toMap());
}
  }

  void _saveMessageToMessageSubcollection({required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String senderUsername,
    required String? receiverUsername,
    required MessageEnum messageType,
    required MessageReply? messageReply,
  required bool isGroupChat}) async {
    final message = Message(
        senderId: auth.currentUser!.uid,
        receiverId: receiverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        repliedTo: messageReply == null ? '' : messageReply.isMe
            ? senderUsername
            : receiverUsername?? '',
        repliedMessage: messageReply == null ? '' : messageReply.message,
        repliedMessageType: messageReply == null ? MessageEnum.text:messageReply.messageEnum
    );
    if(isGroupChat){
     await firestore.collection('groups').doc(receiverUserId).collection('chats').doc(messageId).set(message.toMap()) ;
    }
    else {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        // var chatContact=_getChatContactModel(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: user.uid,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }
  Stream<List<GroupModel>> getChatGroups() {
    return firestore
        .collection('groups')
        .snapshots()
        .map((event) {
      List<GroupModel> groups = [];
      for (var document in event.docs) {
        var chatGroup = GroupModel.fromMap(document.data());
        if(chatGroup.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(chatGroup);
        }
      }
      return groups;
    });
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent',descending: true)
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }
  Stream<List<Message>> getGroupChatStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timeSent', descending: true)
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String fileUrl = await ref.read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase("chat/${messageEnum.type}/${senderUserData
          .uid}/$receiverUserId/$messageId", file);
      UserModel? receiverUserData;
      if(!isGroupChat) {
        var userDataMap = await firestore.collection('users')
            .doc(receiverUserId)
            .get();
        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }
      String contactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = "📷 Image";
          break;
        case MessageEnum.video:
          contactMsg = "📹 Video";
          break;
        case MessageEnum.audio:
          contactMsg = "🔉 Audio";
          break;
        case MessageEnum.gif:
          contactMsg = "GIF";
          break;
        default:
          contactMsg = "GIF";
      }
      _saveDataToContactSubcollection(senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          text
              : contactMsg,
          timeSent: timeSent,
          receiverUserId: receiverUserId,
      isGroupChat:isGroupChat);
      _saveMessageToMessageSubcollection(receiverUserId: receiverUserId,
          text: fileUrl,
          timeSent: timeSent,
          messageId: messageId,
          senderUsername: senderUserData.name,
          receiverUsername: receiverUserData?.name,
          messageType: messageEnum,
          messageReply: messageReply,
          isGroupChat:isGroupChat
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGifMessage({required BuildContext context,
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUserData, required MessageReply? messageReply,required bool isGroupChat }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserData;
      if(!isGroupChat) {
        var userDataMap =
        await firestore.collection('users').doc(receiverUserId).get();
        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }
      var messageId = const Uuid().v1();

      _saveDataToContactSubcollection(
          timeSent: timeSent,
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          receiverUserId: receiverUserId,
          text: 'GIF',
          isGroupChat:isGroupChat);
      _saveMessageToMessageSubcollection(
          receiverUserId: receiverUserId,
          text: gifUrl,
          timeSent: timeSent,
          receiverUsername: receiverUserData?.name,
          senderUsername: senderUserData.name,
          messageType: MessageEnum.gif,
          messageId: messageId,
          messageReply: messageReply,
          isGroupChat:isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
  void seenFeature(BuildContext context,String userId,String messageId) async {
    try{
      await firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({"isSeen":true});
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(userId)
          .collection('messages')
          .doc(messageId)
          .update({"isSeen":true});
    }
    catch(e){
      showSnackBar(context: context, content: e.toString());}
  }
}
