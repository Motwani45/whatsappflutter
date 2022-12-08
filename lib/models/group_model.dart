class GroupModel{
  final String name;
  final String groupId;
  final String lastMessage;
  final List<String> membersUid;
  final String groupPic;
  final String senderId;

  const GroupModel({
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.membersUid,
    required this.groupPic,
    required this.senderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'groupId': this.groupId,
      'lastMessage': this.lastMessage,
      'membersUid': this.membersUid,
      'groupPic': this.groupPic,
      'senderId': this.senderId,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      lastMessage: map['lastMessage'] as String,
      membersUid: List<String>.from(map['membersUid']),
      groupPic: map['groupPic'] as String,
      senderId: map['senderId'] as String,
    );
  }
}