import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:flutterwhatsappclone/features/chat/repositories/chat_repository.dart';
import 'package:flutterwhatsappclone/models/chat_contact.dart';
import 'package:flutterwhatsappclone/models/message.dart';
import 'package:flutterwhatsappclone/models/user_model.dart';
final chatControllerProvider=Provider((ref) {
  final chatRepository=ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});
class ChatController{
  final ChatRepository chatRepository;
  final ProviderRef ref;

  const ChatController({
    required this.chatRepository,
    required this.ref,
  });
  void sendTextMessage( {required BuildContext context,
    required String text,
    required String receiverUserId}){
    ref.read(userDataAuthProvider).whenData((value) {

      chatRepository.sendTextMessage(context: context, text: text, receiverUserId: receiverUserId, senderUserData: value!);
    });

  }
  void sendGifMessage( {required BuildContext context,
    required String gifUrl,
    required String receiverUserId}){
    //   https://giphy.com/gifs/studiosoriginals-l0MYDMt4Iyp1R84fu change to
    // https://i.giphy.com/media/l0MYDMt4Iyp1R84fu/200.gif
    int gifUrlPartIndex=gifUrl.lastIndexOf('-')+1;
    String gifBaseUrl="https://i.giphy.com/media/";
    String gifFullUrl="$gifBaseUrl${gifUrl.substring(gifUrlPartIndex)}/200.gif";

    ref.read(userDataAuthProvider).whenData((value) {

      chatRepository.sendGifMessage(context: context, gifUrl: gifFullUrl, receiverUserId: receiverUserId, senderUserData: value!);
    });

  }
Stream<List<ChatContact>> getChatContacts(){
    return chatRepository.getChatContacts();
}
Stream<List<Message>> getChatStream(String receiverUserId){
    return chatRepository.getChatStream(receiverUserId);
}
  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required MessageEnum messageEnum
  }){
    ref.read(userDataAuthProvider).whenData((value) {
    chatRepository.sendFileMessage(context: context, file: file, receiverUserId: receiverUserId, senderUserData: value!, ref: ref, messageEnum: messageEnum);
  });
  }

}