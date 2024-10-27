import 'package:chat_app/model/Userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;
final authdb = FirebaseAuth.instance;

class GetDataService {
  static List<Userdata> userslist = [];

  static Stream<List<Userdata>> getdataStream() {
    final docref = db.collection("Users");

    return docref.snapshots().map((snapshot) {
      print("Data loaded");
      userslist.clear();
      for (var doc in snapshot.docs) {
        if (doc.id != authdb.currentUser!.uid) {
          userslist.add(
            Userdata.fromfirestore(doc.data(), doc.id),
          );
        }
      }
      return userslist;
    });
  }
}
