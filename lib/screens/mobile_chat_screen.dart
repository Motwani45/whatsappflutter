import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/info.dart';
import 'package:flutterwhatsappclone/widgets/chat_list.dart';

class MobileChatScreen extends StatelessWidget {
  final int index;

  MobileChatScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Container(
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
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              info[index]['profilePic'].toString(),
                              scale: 0.3),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          info[index]['name'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          iconSize: MediaQuery.of(context).size.width * 0.05,
                          icon: const Icon(Icons.video_call),
                        ),
                        IconButton(
                          onPressed: () {},
                          iconSize: MediaQuery.of(context).size.width * 0.05,
                          icon: const Icon(Icons.call),
                        ),
                        IconButton(
                          onPressed: () {},
                          iconSize: MediaQuery.of(context).size.width * 0.05,
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(child: ChatList()),
              Container(
                decoration: BoxDecoration(
                    color: mobileChatBoxColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: 'Type a message!',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                          Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                          Icon(
                            Icons.money,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
