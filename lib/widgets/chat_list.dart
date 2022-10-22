import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/info.dart';
import 'package:flutterwhatsappclone/widgets/my_message_card.dart';
import 'package:flutterwhatsappclone/widgets/sender_message_card.dart';

class ChatList extends StatelessWidget {
  ChatList({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context)
  {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return
      // Expanded(child:
      ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            if (messages[index]['isMe'] == true) {
              return MyMessageCard(
                message: messages[index]['text'].toString(),
                date: messages[index]['time'].toString(),
              );
            }
            return SenderMessageCard(
              message: messages[index]['text'].toString(),
              date: messages[index]['time'].toString(),
            );
          },
      // ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent,
      );
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }
}
