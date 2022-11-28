import 'package:flutterwhatsappclone/common/enums/message_enum.dart';
import 'dart:core';

class Message{
  final String  senderId;
  final String  receiverId;
  final String  text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  const Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
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
      'repliedMessage': this.repliedMessage,
      'repliedTo': this.repliedTo,
      'repliedMessageType': this.repliedMessageType.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      text: map['text'] as String,
      type: (map['type'] as String).toEnum(),
      timeSent: map['timeSent'].toDate(),
      // (map['timeSent'] as DateTime)
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
      repliedMessage: map['repliedMessage'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }
}