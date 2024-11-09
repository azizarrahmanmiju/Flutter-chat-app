import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;

void sendMessage(String recid,
    {String? message, String? fileUrl, String? fileType}) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  final messagesData = {
    'senderId': currentUser!.uid,
    'recipientId': recid,
    'message': message ?? '',
    'timestamp': FieldValue.serverTimestamp(),
    'status': 'sent',
    'image': fileUrl ?? '',
    'fileType': fileType ?? 'text',
  };

  await db.collection('Messages').add(messagesData);

  // Update lastMessageTime for both sender and recipient
  await db.collection('Users').doc(currentUser.uid).update({
    'timestamp': FieldValue.serverTimestamp(),
  });
  await db.collection('Users').doc(recid).update({
    'timestamp': FieldValue.serverTimestamp(),
  });
}
