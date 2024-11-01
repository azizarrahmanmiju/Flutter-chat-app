import 'package:chat_app/model/Userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;

Stream<Userdata> fetchcurrentuserdata() {
  final user = FirebaseAuth.instance.currentUser;
  return db.collection("Users").doc(user!.uid).snapshots().map((snapshot) =>
      Userdata.fromfirestore(
          snapshot.data() as Map<String, dynamic>, snapshot.id));
}
