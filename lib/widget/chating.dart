import 'package:chat_app/service/getmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chating extends StatefulWidget {
  const Chating({
    super.key,
    required this.recipientid,
    required this.imageurl,
  });

  final String recipientid;
  final String imageurl;

  @override
  State<Chating> createState() => _ChatingState();
}

class _ChatingState extends State<Chating> {
  String? selectedmessageid;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: StreamBuilder(
          stream: GetMessage.getMessages(widget.recipientid),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No messages'));
            }
            var messages = snapshot.data!.docs;

            return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot message = messages[index];

                  final isMe = message['senderId'] ==
                      FirebaseAuth.instance.currentUser!.uid;

                  final timestamp = message['timestamp'] != null
                      ? (message['timestamp'] as Timestamp).toDate()
                      : null;
                  // check if message is from me
                  return ListTile(
                    title: Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: isMe ? 150 : 0,
                          right: isMe ? 0 : 150,
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedmessageid =
                                      message.id == selectedmessageid
                                          ? null
                                          : message.id;
                                });
                                print(selectedmessageid);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 139, 139, 139)
                                            .withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(2, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12),
                                    color: isMe
                                        ? const Color.fromARGB(
                                            255, 255, 255, 255)
                                        : const Color.fromARGB(
                                            255, 48, 47, 47)),
                                child: Text(
                                  message['message'],
                                  style: TextStyle(
                                      color: isMe
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 255, 255, 255)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            selectedmessageid == message.id
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: isMe
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        timestamp != null
                                            ? "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}"
                                            : '',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.black),
                                      ),
                                      const SizedBox(width: 8),
                                      isMe
                                          ? message['status'] == 'seen'
                                              ? SizedBox(
                                                  height: 14,
                                                  width: 14,
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            widget.imageurl),
                                                  ),
                                                )
                                              : Image.asset(
                                                  height: 14,
                                                  width: 14,
                                                  message['status'] == 'sent'
                                                      ? 'lib/icons/sent.png'
                                                      : 'lib/icons/tick.png')
                                          : const Text("")
                                    ],
                                  )
                                : const SizedBox(
                                    height: 0,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      )
    ]);
  }
}
