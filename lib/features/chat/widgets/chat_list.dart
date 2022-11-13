import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/widgets/loader.dart';
import 'package:flutterwhatsappclone/features/chat/controller/chat_controller.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/sender_message_card.dart';
import 'package:flutterwhatsappclone/info.dart';
import 'package:flutterwhatsappclone/models/message.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/my_message_card.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverId;
  const ChatList( {
    Key? key,required this.receiverId
  }) : super(key: key);

  @override
  ConsumerState createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {



  final ScrollController _scrollController = ScrollController();
@override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context)
  {
    scrolling();
    return
      StreamBuilder<List<Message>>(
        stream: ref.read(chatControllerProvider).getChatStream(widget.receiverId),
        builder: (context, snapshot) {
          scrolling();
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Loader();
          }
          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
              controller: _scrollController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messageData=snapshot.data![index];
                final timeData=snapshot.data![index].timeSent;
                if (messageData.senderId!=widget.receiverId) {
                  return MyMessageCard(
                    message: messageData.text,
                    date: DateFormat.Hm().format(timeData),
                    type: messageData.type,
                  );
                }
                return SenderMessageCard(
                  message: messageData.text,
                  date: DateFormat.Hm().format(timeData),
                  type: messageData.type,

                );
              },
          // ),
    );
        }
      );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent,
      );
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }
  void scrolling(){
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }
}
