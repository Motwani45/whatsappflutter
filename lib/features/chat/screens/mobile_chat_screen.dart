import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/widgets/loader.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/bottom_chat_field.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/user_info_bar.dart';
import 'package:flutterwhatsappclone/info.dart';
import 'package:flutterwhatsappclone/models/user_model.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/chat_list.dart';
import 'package:velocity_x/velocity_x.dart';

class MobileChatScreen extends ConsumerWidget {
  final String name;
  final String uid;

  static const String routeName = '/mobile_chat_screen';

  const MobileChatScreen({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: dividerColor),
            ),
            image: DecorationImage(
              image: AssetImage(
                "assets/backgroundImage.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              UserInfoBar(uid: uid, name: name),
              Expanded(child: ChatList(receiverId: uid,)),
              BottomChatField(receiverUserId: uid,username:name),
            ],
          ),
        ),
      ),
    );
  }
}




