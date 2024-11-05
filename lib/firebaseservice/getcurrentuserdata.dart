import 'package:chat_app/model/Userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;

Stream<Userdata> fetchcurrentuserdata() {
  final user = FirebaseAuth.instance.currentUser;
  final respons = db.collection("Users").doc(user!.uid).snapshots();

  return respons.map((data) =>
      Userdata.fromfirestore(data.data() as Map<String, dynamic>, data.id));
}
