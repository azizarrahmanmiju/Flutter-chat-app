import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io'; // For file handling

Future<String> uploadFile(File file, String fileType) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  final storageRef = FirebaseStorage.instance
      .ref()
      .child('chat_files')
      .child(currentUser!.uid)
      .child('${DateTime.now().toIso8601String()}.$fileType');

  await storageRef.putFile(file);
  final fileUrl = await storageRef.getDownloadURL();
  return fileUrl;
}
