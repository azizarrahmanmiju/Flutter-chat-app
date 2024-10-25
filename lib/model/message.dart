import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String message;
  final String senderId;
  final String recipientId;
  final String status;
  final Timestamp timestamp;

  Message({
    required this.id,
    required this.message,
    required this.senderId,
    required this.recipientId,
    required this.status,
    required this.timestamp,
  });

  factory Message.fromFirestore(Map<String, dynamic> data, String id) {
    return Message(
      id: id, // document ID
      message: data['message'],
      senderId: data['senderId'],
      recipientId: data['recipientId'],
      status: data['status'],
      timestamp: data['timestamp'],
    );
  }
}
