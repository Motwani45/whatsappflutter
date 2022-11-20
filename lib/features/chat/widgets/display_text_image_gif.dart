import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/video_player_item.dart';
class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGif({Key? key,required this.type,required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying=false;
    final AudioPlayer audioPlayer=AudioPlayer();
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
        messageWidget=StatefulBuilder(
          builder: (context,setState) {
            return IconButton(constraints:const BoxConstraints(minWidth: 100),onPressed:() async{

              if(isPlaying){
                await audioPlayer.pause();
              }
              else{
                await audioPlayer.play(UrlSource(message));
              }
              setState((){
              isPlaying=!isPlaying;
              });
            }, icon:Icon(isPlaying?Icons.pause_circle:Icons.play_circle,size: 30,));
          }
        );
        break;
      case MessageEnum.video:
          messageWidget=VideoPlayerItem(videoUrl: message,);
        break;
      case MessageEnum.gif:

        messageWidget=CachedNetworkImage(imageUrl: message,
          progressIndicatorBuilder:(context,string,progress){
            return CircularProgressIndicator(
              backgroundColor: backgroundColor,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              value: progress.progress,
            );

          },);
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
