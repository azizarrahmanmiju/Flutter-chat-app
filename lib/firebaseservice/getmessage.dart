import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var db = FirebaseFirestore.instance;

class GetMessage {
  static Stream<QuerySnapshot> getMessages(String recipientId) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Query to get the messages between the current user and the recipient
    final msgresponse = db
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

    msgresponse.first.then((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc['recipientId'] == currentUser.uid) {
          db.collection('Messages').doc(doc.id).update({
            'status': 'seen',
          });
        }
      }
    });
    return msgresponse;
  }
}

Stream<QuerySnapshot> getLastMessageStream(String recipientId) {
  final currentUser = FirebaseAuth.instance.currentUser;

  final response = db
      .collection('Messages')
      .where('senderId', whereIn: [currentUser!.uid, recipientId])
      .where('recipientId', whereIn: [currentUser.uid, recipientId])
      .orderBy('timestamp', descending: true)
      .limit(1)
      .snapshots();

  response.first.then((snapshot) {
    for (var doc in snapshot.docs) {
      if (doc['recipientId'] == currentUser.uid) {
        db.collection('Messages').doc(doc.id).update({
          'status': 'delivered',
        });
      }
    }
  });
  return response;
}
