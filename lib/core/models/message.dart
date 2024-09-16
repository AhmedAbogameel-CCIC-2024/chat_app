import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String senderUID;
  final Timestamp sentAt;

  Message({
    required this.message,
    required this.senderUID,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      senderUID: json['sender_uid'],
      sentAt: json['sent_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender_uid': senderUID,
      'sent_at': sentAt,
    };
  }
}
