import 'package:chat_app/model/Userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

Stream<Userdata> fetchcurrentuserdata() {
  return db.collection("Users").doc(user!.uid).snapshots().map((snapshot) =>
      Userdata.fromfirestore(
          snapshot.data() as Map<String, dynamic>, snapshot.id));
}
