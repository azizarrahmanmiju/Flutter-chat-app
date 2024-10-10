import 'package:chat_app/service/getmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chating extends StatelessWidget {
  const Chating({
    super.key,
    required this.recipientid,
  });

  final String recipientid;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
          child: StreamBuilder(
              stream: Getmessage.getMessages(recipientid),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return Center(child: Text('No messages'));
                }
                var messages = snapshot.data!.docs;

                return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot message = messages[index];

                      final isMe = message['senderId'] ==
                          FirebaseAuth.instance.currentUser!.uid;
                      // check if message is from me
                      return ListTile(
                        title: Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: isMe ? 150 : 0,
                              right: isMe ? 0 : 150,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: isMe
                                      ? const Color.fromARGB(255, 209, 209, 209)
                                      : Theme.of(context).colorScheme.primary),
                              child: Text(
                                message['message'],
                                style: TextStyle(
                                    color: isMe ? Colors.black : Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }))
    ]);
  }
}
