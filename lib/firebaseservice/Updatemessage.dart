import 'package:cloud_firestore/cloud_firestore.dart';

final firedb = FirebaseFirestore.instance;

void Updatemessage(messageId, message) {
  firedb.collection("Messages").doc(messageId).update({'message': message});
}
