import 'package:chat_app/widget/chating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var db = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  final String recipientimage;

  const ChatScreen({
    Key? key,
    required this.recipientId,
    required this.recipientName,
    required this.recipientimage,
  }) : super(key: key);

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
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                widget.recipientimage,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "${widget.recipientName}",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Chating(recipientid: widget.recipientId),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              bottom: 30,
              top: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(146, 95, 95, 95),
                              blurRadius: 2,
                              blurStyle: BlurStyle.normal,
                              spreadRadius: 1,
                              offset: Offset(0, 1))
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 236, 246, 250),
                            Color.fromARGB(255, 252, 238, 236),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        bottom: 5,
                        top: 5,
                      ),
                      child: TextField(
                        autofocus: false,
                        maxLines: null,
                        keyboardType: TextInputType.text,
                        controller: _messageController,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      sendMessage(widget.recipientId, _messageController.text);
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String recid, String message) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    _messageController.clear();

    if (currentUser != null && message.isNotEmpty) {
      await db.collection('Messages').add({
        'senderId': currentUser.uid,
        'recipientId': recid,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(), // Add timestamp for ordering
      }).then((value) {
        print('Message sent successfully');
      }).catchError((error) {
        print('Failed to send message: $error');
      });
    }
  }
}
