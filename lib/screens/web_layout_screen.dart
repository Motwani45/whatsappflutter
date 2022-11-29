import 'package:flutter/material.dart';
import 'package:flutterwhatsappclone/colors.dart';
import 'package:flutterwhatsappclone/info.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/chat_list.dart';
import 'package:flutterwhatsappclone/widgets/web_chat_appbar.dart';
import 'package:flutterwhatsappclone/widgets/contacts_list.dart';
import 'package:flutterwhatsappclone/features/chat/widgets/my_message_card.dart';
import 'package:flutterwhatsappclone/widgets/web_profile_bar.dart';
import 'package:flutterwhatsappclone/widgets/web_search_bar.dart';

class WebLayoutScreen extends StatelessWidget {
  const WebLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  WebProfileBar(),
                  WebSearchBar(),
                  ContactsList(),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
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
                const ChatAppBar(),
                const SizedBox(height: 20),
                Expanded(
                  child: ChatList(receiverId: '',username: '',),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: dividerColor),
                    ),
                    color: chatBarMessage,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
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
                      Expanded(
                        child:  TextField(
                          cursorColor: Colors.white,
                          cursorHeight: 23,
                          cursorWidth: 2,
                          style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: searchBarColor,
                              hintText: 'Type a message',
                              hintStyle: TextStyle(fontSize: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(left: 20),
                            ),
                          ),
                        ),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.mic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
