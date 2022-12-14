import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
import 'package:flutterwhatsappclone/common/providers/message_reply_provider.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:flutterwhatsappclone/features/chat/repositories/chat_repository.dart';
import 'package:flutterwhatsappclone/models/chat_contact.dart';
import 'package:flutterwhatsappclone/models/group_model.dart';
import 'package:flutterwhatsappclone/models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  const ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required bool isGroupChat
  }) {
    final messageReply=ref.read(messageReplyProvider);
    ref.read(currentUserDataAuthProvider).whenData((value) {
      chatRepository.sendTextMessage(
          context: context,
          text: text,
          receiverUserId: receiverUserId,
          senderUserData: value!,
      messageReply:messageReply,
          isGroupChat:isGroupChat);
    });
  }

  void sendGifMessage(
      {required BuildContext context,
      required String gifUrl,
      required String receiverUserId,
        required bool isGroupChat}) {
    //   https://giphy.com/gifs/studiosoriginals-l0MYDMt4Iyp1R84fu change to
    // https://i.giphy.com/media/l0MYDMt4Iyp1R84fu/200.gif
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifBaseUrl = "https://i.giphy.com/media/";
    String gifFullUrl =
        "$gifBaseUrl${gifUrl.substring(gifUrlPartIndex)}/200.gif";
    final messageReply=ref.read(messageReplyProvider);
    ref.read(currentUserDataAuthProvider).whenData((value) {
      chatRepository.sendGifMessage(
          context: context,
          gifUrl: gifFullUrl,
          receiverUserId: receiverUserId,
          senderUserData: value!,messageReply:messageReply,
      isGroupChat:isGroupChat);
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }
  Stream<List<GroupModel>> getChatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }
  Stream<List<Message>> getGroupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }
  void seenFeature(BuildContext context,String userId,String messageId){
    chatRepository.seenFeature(context, userId, messageId);
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String receiverUserId,
      required MessageEnum messageEnum,required bool isGroupChat}) {
    final messageReply=ref.read(messageReplyProvider);
    ref.read(currentUserDataAuthProvider).whenData((value) {
      chatRepository.sendFileMessage(
          context: context,
          file: file,
          receiverUserId: receiverUserId,
          senderUserData: value!,
          ref: ref,
          messageEnum: messageEnum,messageReply:messageReply,
          isGroupChat:isGroupChat);
    });
  }
}
