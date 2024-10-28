import 'package:chat_app/model/Userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

Stream<Userdata> fetchcurrentuserdata() {
  if (user == null || user!.uid == null || user!.uid.isEmpty) {
    return Stream.empty();
  }

  return db.collection("Users").doc(user!.uid).snapshots().map((snapshot) =>
      Userdata.fromfirestore(
          snapshot.data() as Map<String, dynamic>, snapshot.id));
}
