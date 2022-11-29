import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
import 'package:flutterwhatsappclone/common/providers/message_reply_provider.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/display_text_image_gif.dart';
import 'package:flutterwhatsappclone/models/user_model.dart';
import 'package:swipe_to/swipe_to.dart';

import 'message_reply_preview.dart';

class MyMessageCard extends ConsumerWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final Size size;
  final bool isSeen;

  const MyMessageCard({Key? key, required this.message, required this.date,required this.type, required this.isSeen,required this.onRightSwipe, required this.repliedText, required this.username, required this.repliedMessageType,required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return SwipeTo(onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: repliedText.isEmpty?type==MessageEnum.text?const EdgeInsets.only(
                    left: 8,
                    top: 5,
                    right: 55,
                    bottom: 20,
                  ):
                  const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 5,
                    bottom: 25): const EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 5,
                      bottom: 25),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      repliedText.isEmpty?const SizedBox():MessageReplyPreview(color: repliedMessageColor, size: size, isCancelable:false,
                        previousMessageReply: MessageReply(
                                    message: repliedText,
                                    isMe: checkIsMe(ref),
                                    messageEnum: repliedMessageType), username: username,
                              ),
                      DisplayTextImageGif(type: type,message: message,size:size,isReply:false),
                    ],
                  )
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style:const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        isSeen?
                        Icons.done_all:Icons.done,
                        size: 20,
                        color: isSeen?Colors.lightBlueAccent:Colors.white60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkIsMe(WidgetRef ref) {
    UserModel? currentUserData;
    ref.read(currentUserDataAuthProvider).when(data:(value){
    currentUserData=value;  
    }, error: (obj,stackTrace){
      currentUserData=null;
    }, loading: (){currentUserData=null;});
    return currentUserData!.name==username;
  }
}
