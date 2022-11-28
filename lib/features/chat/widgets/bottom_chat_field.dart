import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
import 'package:flutterwhatsappclone/common/providers/message_reply_provider.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:flutterwhatsappclone/features/chat/controller/chat_controller.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/message_reply_preview.dart';
import 'package:flutterwhatsappclone/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  final String username;

  const BottomChatField({Key? key, required this.receiverUserId,required this.username})
      : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? soundRecorder;
  bool isShowEmoji = false;
  bool isRecordInit = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    soundRecorder = FlutterSoundRecorder();
    openAudio();
    getUserModel(widget.receiverUserId);
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    soundRecorder!.closeRecorder();
    isRecordInit = false;
  }

  void sendFileMessage({required File file, required MessageEnum messageEnum}) {
    ref.read(chatControllerProvider).sendFileMessage(
        context: context,
        file: file,
        receiverUserId: widget.receiverUserId,
        messageEnum: messageEnum);
  }

  void sendGifMessage(
      {required String gifUrl, required MessageEnum messageEnum}) {
    ref.read(chatControllerProvider).sendGifMessage(
          context: context,
          gifUrl: gifUrl,
          receiverUserId: widget.receiverUserId,
        );
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmoji = false;
    });
  }

  void selectGif(BuildContext context) async {
    GiphyGif? gif = await pickGif(context);
    if (gif != null) {
      sendGifMessage(gifUrl: gif.url, messageEnum: MessageEnum.gif);
    }
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmoji = true;
    });
  }

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void hideKeyboard() {
    focusNode.unfocus();
  }

  void toggleEmojiKeyboardContainer() {
    if (isShowEmoji) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(file: image, messageEnum: MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(file: video, messageEnum: MessageEnum.video);
    }
  }

  void sendTextMessage() async {
    ref.read(chatControllerProvider).sendTextMessage(
        context: context,
        text: _messageController.text.trim(),
        receiverUserId: widget.receiverUserId);
    _messageController.clear();
    onChangeData(_messageController.text);
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendVoiceMessage() async {
    var tempDir = await getTemporaryDirectory();
    var path = '${tempDir.path}/flutter_sound.aac';
    if (!isRecordInit) {
      return;
    }
    if (isRecording) {
      await soundRecorder!.stopRecorder();
      sendFileMessage(file: File(path), messageEnum: MessageEnum.audio);
      ref.read(messageReplyProvider.state).update((state) => null);
    } else {
      await soundRecorder!.startRecorder(toFile: path);
    }
    setState(() {
      isRecording = !isRecording;
    });
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone Permission Not Allowed');
    }
    await soundRecorder!.openRecorder();
    isRecordInit = true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final messageReply=ref.watch(messageReplyProvider);
    final isShowMessageReply=messageReply!=null;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Column(
        children: [
          // isShowMessageReply? const MessageReplyPreview():const SizedBox(),
          Row(
            children: [
              3.widthBox,
              Container(
                width: MediaQuery.of(context).size.width * 0.84,
                decoration: BoxDecoration(
                    color: mobileChatBoxColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    isShowMessageReply? MessageReplyPreview(size:MediaQuery.of(context).size,color: repliedBottomChatMessageColor,isCancelable:true,previousMessageReply: null, username:widget.username,):const SizedBox(),
                    Row(
                      children: [
                        IconButton(
                          onPressed: toggleEmojiKeyboardContainer,
                          icon: Icon(
                            isShowEmoji ? Icons.keyboard : Icons.emoji_emotions,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            selectGif(context);
                          },
                          icon: const Icon(
                            Icons.gif_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            onTap: () {
                              if (isShowEmoji) {
                                hideEmojiContainer();
                              }
                            },
                            focusNode: focusNode,
                            keyboardType: TextInputType.text,
                            controller: _messageController,
                            onChanged: (val) {
                              onChangeData(val);
                            },
                            maxLines: 20,
                            minLines: 1,
                            cursorColor: messageColor,
                            cursorHeight: 25,
                            decoration: const InputDecoration(
                              hintText: ' Message',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 17),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              3.widthBox,
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.06,
                backgroundColor: const Color.fromARGB(255, 0, 168, 132),
                child: GestureDetector(
                  onTap: isShowSendButton ? sendTextMessage : sendVoiceMessage,
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          isShowEmoji
              ? SizedBox(
                  height: size.height * 0.35,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      setState(() {
                        _messageController.text =
                            _messageController.text + emoji.emoji;
                        onChangeData(_messageController.text);
                      });
                    },
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  void onChangeData(String val) {
    if (val.trim().isEmpty) {
      setState(() {
        isShowSendButton = false;
      });
    } else {
      setState(() {
        isShowSendButton = true;
      });
    }
  }

  Future<bool> _onBackPressed() async {
    if (isShowEmoji) {
      hideEmojiContainer();
      return false;
    }
    return true;
  }

  getUserModel(String receiverUserId) {
    UserModel? userModel=
    ref.read(userDataAuthProvider(widget.receiverUserId)).value;
    return userModel;
  }
}
