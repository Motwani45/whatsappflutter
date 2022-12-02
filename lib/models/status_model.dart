class Status{
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;

  const Status({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'username': this.username,
      'phoneNumber': this.phoneNumber,
      'photoUrl': this.photoUrl,
      'createdAt': this.createdAt,
      'profilePic': this.profilePic,
      'statusId': this.statusId,
      'whoCanSee': this.whoCanSee,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] as String,
      username: map['username'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoUrl: map['photoUrl'] as List<String>,
      createdAt: map['createdAt'].toDate(),
      profilePic: map['profilePic'] as String,
      statusId: map['statusId'] as String,
      whoCanSee: map['whoCanSee'] as List<String>,
    );
  }
}