import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String senderId;
  late String receiverId;
  late String content;
  late Timestamp timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp,
    };
  }

  Message.fromMap(dynamic obj) {
    senderId = obj['senderId'];
    receiverId = obj["receiverId"];
    content = obj["content"];
    timestamp = obj["timestamp"];
  }
}

