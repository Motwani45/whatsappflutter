import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/common/widgets/loader.dart';
import 'package:flutterwhatsappclone/features/auth/controller/auth_controller.dart';
import 'package:flutterwhatsappclone/models/group_model.dart';
import 'package:flutterwhatsappclone/models/user_model.dart';
import 'package:velocity_x/velocity_x.dart';

class UserInfoBar extends ConsumerWidget {
  const UserInfoBar({
    Key? key,
    required this.uid,
    required this.name,
    required this.isGroupChat
  }) : super(key: key);

  final String uid;
  final String name;
  final bool isGroupChat;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      color: appBarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                iconSize: MediaQuery.of(context).size.width * 0.07,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
             isGroupChat?groupStreamBuilder(ref):chatStreamBuilder(ref),
            ],
          ),
          // ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                iconSize: MediaQuery.of(context).size.width * 0.07,
                icon: const Icon(Icons.video_call),
              ),
              IconButton(
                onPressed: () {},
                iconSize: MediaQuery.of(context).size.width * 0.07,
                icon: const Icon(Icons.call),
              ),
              IconButton(
                onPressed: () {},
                iconSize: MediaQuery.of(context).size.width * 0.07,
                icon: const Icon(Icons.more_vert),
              ),
            ],
          )
        ],
      ),
    );
  }
  StreamBuilder chatStreamBuilder(WidgetRef ref){
    bool isLoaded=false;
    return StreamBuilder<UserModel>(
        stream: ref
            .read(authControllerProvider)
            .userDataById(uid),
        builder: (context, snapShot) {
          if(!isLoaded&&snapShot.connectionState==ConnectionState.waiting){
            isLoaded=true;
            return const Loader();
          }
          return
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapShot.data!.profilePic,
                      scale: 0.3),
                ),
                8.widthBox,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Text(snapShot.data!.isOnline
                        ? 'online'
                        : 'offline')
                  ],
                ),
              ],
            );
        });
  }
  StreamBuilder groupStreamBuilder(WidgetRef ref){
    bool isLoaded=false;
    return StreamBuilder<GroupModel>(
        stream: ref
            .read(authControllerProvider)
            .groupDataById(uid),
        builder: (context, snapShot) {
          if(!isLoaded&&snapShot.connectionState==ConnectionState.waiting){
            isLoaded=true;
            return const Loader();
          }
          return
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapShot.data!.groupPic,
                      scale: 0.3),
                ),
                8.widthBox,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            );
        });
  }
}