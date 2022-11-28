import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/providers/message_reply_provider.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/display_text_image_gif.dart';

class MessageReplyPreview extends ConsumerWidget {
  final Size size;
  final Color color;
  final bool isCancelable;
  final MessageReply? previousMessageReply;
  final String username;
  const MessageReplyPreview({
    Key? key,
    required this.color,
  required this.size,required this.isCancelable,required this.previousMessageReply,required this.username}) : super(key: key);
 void cancelReply(WidgetRef ref){
   ref.read(messageReplyProvider.state).update((state) => null);
 }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply=previousMessageReply ?? ref.watch(messageReplyProvider);
    return Container(
      margin:const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20)),
      width: 350,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child:
                  Text(
                    messageReply!.isMe? 'You':username,style: const TextStyle(fontWeight: FontWeight.bold),
                  )
              ),
              isCancelable?GestureDetector(
                child: const Icon(Icons.close,size: 20,),
                onTap: (){
cancelReply(ref);
                },
              ):const SizedBox()
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          DisplayTextImageGif(type: messageReply.messageEnum,
            message: messageReply.message,
            size: size,
            isReply: true,
          )
        ],
      ),
    );
  }
}