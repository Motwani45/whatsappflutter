import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGif({Key? key,required this.type,required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget messageWidget;
    switch(type){
      case MessageEnum.text:
        messageWidget=Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        );
        break;
      case MessageEnum.image:
        messageWidget=CachedNetworkImage(imageUrl: message,
        progressIndicatorBuilder:(context,string,progress){
          return CircularProgressIndicator(
            backgroundColor: backgroundColor,
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            value: progress.progress,
          );

          },);
        break;
      case MessageEnum.audio:
        break;
      case MessageEnum.video:
        break;
      case MessageEnum.gif:
        break;
      default:
        messageWidget=Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        );
    }
    return messageWidget;
  }
}
