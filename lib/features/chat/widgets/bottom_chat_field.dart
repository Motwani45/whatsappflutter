
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
import 'package:flutterwhatsappclone/common/utils/utils.dart';
import 'package:flutterwhatsappclone/features/chat/controller/chat_controller.dart';
import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({
    Key? key,
    required this.receiverUserId
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController=TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }
  void sendFileMessage({
  required File file,required MessageEnum messageEnum
}){
    ref.read(chatControllerProvider).sendFileMessage(context: context, file: file, receiverUserId: widget.receiverUserId, messageEnum: messageEnum);
  }
  void selectImage() async{
    File? image=await pickImageFromGallery(context);
    if(image!=null){
      sendFileMessage(file: image, messageEnum: MessageEnum.image);
    }
}
void sendTextMessage() async{
    ref.read(chatControllerProvider).sendTextMessage(context: context, text: _messageController.text.trim(), receiverUserId:widget.receiverUserId);
    _messageController.clear();
}
void sendVoiceMessage(){
showSnackBar(context: context, content: "Voice message cant be send");
}
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.87,
            decoration: BoxDecoration(
                color: mobileChatBoxColor,
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.emoji_emotions,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.gif_outlined,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _messageController,
                    onChanged: (val) {
                      if (val.trim().isEmpty) {
                        setState(() {
                          isShowSendButton = false;
                        });
                      } else {
                        setState(() {
                          isShowSendButton = true;
                        });
                      }
                    },
                    maxLines: 20,
                    minLines: 1,
                    cursorColor: messageColor,
                    cursorHeight: 25,
                    decoration:const InputDecoration(
                      hintText: ' Message',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
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
                  onPressed:selectImage,
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.attach_file,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CircleAvatar(
              // radius: MediaQuery.of(context).size.width*0.07,
              backgroundColor: const Color.fromARGB(255, 0, 168, 132),
              child: GestureDetector(
                onTap: isShowSendButton?sendTextMessage:sendVoiceMessage,
                child: Icon(
                  isShowSendButton ? Icons.send : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
