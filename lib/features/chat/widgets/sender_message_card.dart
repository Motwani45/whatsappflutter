import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
import 'package:flutterwhatsappclone/common/providers/message_reply_provider.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/display_text_image_gif.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/message_reply_preview.dart';
import 'package:flutterwhatsappclone/models/user_model.dart';
import 'package:swipe_to/swipe_to.dart';

class SenderMessageCard extends ConsumerWidget {
  final String message;
  final String date;
  final Size size;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final MessageEnum type;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                    padding: type == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 25),
                    child: Column(
                      children: [
                        repliedText.isEmpty
                            ? const SizedBox()
                            : MessageReplyPreview(
                          username: username,
                                color: repliedSenderMessageColor,
                                size: size,
                                isCancelable: false,
                                previousMessageReply: MessageReply(
                                    message: repliedText,
                                    isMe: checkIsMe(ref),
                                    messageEnum: repliedMessageType),
                              ),
                        DisplayTextImageGif(
                            type: type,
                            message: message,
                            size: size,
                            isReply: false),
                      ],
                    )),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  const SenderMessageCard({
    required this.message,
    required this.date,
    required this.size,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.type,
  });
  bool checkIsMe(WidgetRef ref){
    UserModel? currentUserData=ref.read(currentUserDataAuthProvider).value;
    return currentUserData!.name==username;
  }
}
