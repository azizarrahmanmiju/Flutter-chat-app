import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var db = FirebaseFirestore.instance;

class Getmessage {
  static Stream<QuerySnapshot> getMessages(String recipientId) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return db
        .collection('Messages')
        .where(
          'senderId',
          whereIn: [currentUser!.uid, recipientId],
          // Use 'or' to match either senderId or recipientId
        )
        .where(
          'recipientId',
          whereIn: [currentUser.uid, recipientId],

          // Use 'or' to match either senderId or recipientId
        )
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
