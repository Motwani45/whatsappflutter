import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
import 'package:flutterwhatsappclone/common/widgets/loader.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/video_player_item.dart';
import 'package:just_audio/just_audio.dart';

class DisplayTextImageGif extends StatefulWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGif(
      {Key? key, required this.type, required this.message})
      : super(key: key);

  @override
  State<DisplayTextImageGif> createState() => _DisplayTextImageGifState();
}

class _DisplayTextImageGifState extends State<DisplayTextImageGif> {
  bool isLoadedAudio = false;
  late AudioPlayer audioPlayer;
  late int fullDuration;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    if (widget.type == MessageEnum.audio) {
      audioPlayer.setUrl(widget.message).then((value) {
        print("Duration::::${value!.inSeconds}");
        isLoadedAudio = true;
        fullDuration = value.inSeconds;
        setState(() {

        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    Widget messageWidget;
    switch (widget.type) {
      case MessageEnum.text:
        messageWidget = Text(
          widget.message,
          style: const TextStyle(
            fontSize: 16,
          ),
        );
        break;
      case MessageEnum.image:
        messageWidget = CachedNetworkImage(
          imageUrl: widget.message,
          progressIndicatorBuilder: (context, string, progress) {
            return CircularProgressIndicator(
              backgroundColor: backgroundColor,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              value: progress.progress,
            );
          },
        );
        break;
      case MessageEnum.audio:
        messageWidget = isLoadedAudio
            ?
        StreamBuilder(
                stream: getAudioStream(audioPlayer, isLoadedAudio),
                builder: (context, snapShot) {
                  print("Loaded ${isLoadedAudio}");
                  print("SnapShot Data= ${snapShot.hasData}");

                  if(snapShot.connectionState==ConnectionState.waiting||!snapShot.hasData){
                    return const Loader();
                  }
                  print("SnapShot currentData= ${snapShot.data!.inSeconds}");
                  int currentDuration=snapShot.data!.inSeconds;
                  if(currentDuration==fullDuration){
                    if(isPlaying){
                      isPlaying=false;
                    }
                  }
                  return IconButton(
                      constraints: const BoxConstraints(minWidth: 100),
                      onPressed: () async {
                        if(currentDuration<fullDuration){
                          if(isPlaying){
                            audioPlayer.pause();
                          }
                          else{
                            audioPlayer.play();
                          }
                        }
                        else if(currentDuration==fullDuration){
                          audioPlayer.setUrl(widget.message);
                        }
                        isPlaying=!isPlaying;
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle,
                        size: 30,
                      ));
                })
            : const Loader();
        break;
      case MessageEnum.video:
        messageWidget = VideoPlayerItem(
          videoUrl: widget.message,
        );
        break;
      case MessageEnum.gif:
        messageWidget = CachedNetworkImage(
          imageUrl: widget.message,
          progressIndicatorBuilder: (context, string, progress) {
            return CircularProgressIndicator(
              backgroundColor: backgroundColor,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              value: progress.progress,
            );
          },
        );
        break;
      default:
        messageWidget = Text(
          widget.message,
          style: const TextStyle(
            fontSize: 16,
          ),
        );
    }
    return messageWidget;
  }

  Stream<Duration?> getAudioStream(
      AudioPlayer audioPlayer, bool isLoadedAudio) {
    return audioPlayer.positionStream;
  }
}
