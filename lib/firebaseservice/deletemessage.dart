import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

final firedb = FirebaseFirestore.instance;

deletmessage(messageId) {
  firedb.collection("Messages").doc(messageId).delete();
}
