import 'package:flutterwhatsappclone/common/enums/message_enum.dart';

class Message{
  final String  senderId;
  final String  receiverId;
  final String  text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;

  const Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': this.senderId,
      'receiverId': this.receiverId,
      'text': this.text,
      'type': this.type.type,
      'timeSent': this.timeSent,
      'messageId': this.messageId,
      'isSeen': this.isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      text: map['text'] as String,
      type: (map['type'] as String).toEnum(),
      timeSent: map['timeSent'].toDate(),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
    );

  }
}