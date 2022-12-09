import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
import 'package:flutterwhatsappclone/common/providers/message_reply_provider.dart';
import 'package:flutterwhatsappclone/common/widgets/loader.dart';
import 'package:flutterwhatsappclone/features/chat/controller/chat_controller.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/sender_message_card.dart';
import 'package:flutterwhatsappclone/models/message.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/my_message_card.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverId;
  final String username;
  final bool isGroupChat;

  const ChatList({Key? key, required this.receiverId, required this.username,required this.isGroupChat})
      : super(key: key);

  @override
  ConsumerState createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref.read(messageReplyProvider.state).update((state) =>
        MessageReply(message: message, isMe: isMe, messageEnum: messageEnum));
  }


  @override
  Widget build(BuildContext context) {
    scrolling();
    return StreamBuilder<List<Message>>(
        stream:widget.isGroupChat?ref.read(chatControllerProvider).getGroupChatStream(widget.receiverId):
            ref.read(chatControllerProvider).getChatStream(widget.receiverId),
        builder: (context, snapshot) {
          scrolling();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              final timeData = snapshot.data![index].timeSent;
              if (!messageData.isSeen &&
                  messageData.receiverId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).seenFeature(
                    context, widget.receiverId, messageData.messageId);
              }
              if (messageData.senderId != widget.receiverId) {
                return MyMessageCard(
                  message: messageData.text,
                  date: DateFormat.Hm().format(timeData),
                  type: messageData.type,
                  size: MediaQuery.of(context).size,
                  repliedText: messageData.repliedMessage,
                  username: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  isSeen:messageData.isSeen,
                  onRightSwipe: () {
                    onMessageSwipe(messageData.text, true, messageData.type);
                  },
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: DateFormat.Hm().format(timeData),
                type: messageData.type,
                size: MediaQuery.of(context).size,
                repliedText: messageData.repliedMessage,
                username: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType,
                onRightSwipe: () {
                  onMessageSwipe(messageData.text, false, messageData.type);
                },
              );
            },
            // ),
          );
        });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        _scrollController.position.minScrollExtent,
      );
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }

  void scrolling() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }
}
