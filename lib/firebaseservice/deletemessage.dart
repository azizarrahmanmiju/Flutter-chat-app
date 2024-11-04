import 'package:cloud_firestore/cloud_firestore.dart';

final firedb = FirebaseFirestore.instance;

deletmessage(messageId) {
  firedb.collection("Messages").doc(messageId).delete();
}
