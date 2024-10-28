import 'dart:io';

import 'package:chat_app/firebaseservice/fileupload.dart';
import 'package:chat_app/firebaseservice/sendmessage.dart';
import 'package:chat_app/widget/chating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

var db = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  final String recipientimage;

  const ChatScreen({
    super.key,
    required this.recipientId,
    required this.recipientName,
    required this.recipientimage,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Hero(
          tag: "hello",
          child: Row(
            children: [
              ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    widget.recipientimage,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.recipientName,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Chating(
              recipientid: widget.recipientId,
              imageurl: widget.recipientimage,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              bottom: 30,
              top: 10,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    pickImage(); // Call the function to pick image
                  },
                ),
                Expanded(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).colorScheme.onBackground,
                            blurRadius: 2,
                            blurStyle: BlurStyle.normal,
                            spreadRadius: 0,
                            offset: Offset(0, 0))
                      ],
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        bottom: 5,
                        top: 5,
                      ),
                      child: TextField(
                        autofocus: false,
                        maxLines: null,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                        keyboardType: TextInputType.text,
                        controller: _messageController,
                        textDirection: TextDirection.ltr,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      sendMessage(
                        widget.recipientId,
                        message: _messageController.text,
                      );
                      _messageController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      ),
    );
  } //======

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      String imageUrl = await uploadFile(image, 'jpg');
      sendMessage(widget.recipientId, fileUrl: imageUrl, fileType: 'image');
    }
  }

  Future<void> pickZipFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['zip']);

    if (result != null) {
      File zipFile = File(result.files.single.path!);
      String zipUrl = await uploadFile(zipFile, 'zip');
      sendMessage(widget.recipientId, fileUrl: zipUrl, fileType: 'zip');
    }
  }
}
