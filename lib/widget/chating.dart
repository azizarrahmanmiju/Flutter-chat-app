import 'package:chat_app/riverpod/smessageid.dart';
import 'package:chat_app/service/getmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Chating extends ConsumerStatefulWidget {
  const Chating({
    super.key,
    required this.recipientid,
    required this.imageurl,
  });

  final String recipientid;
  final String imageurl;

  @override
  ConsumerState<Chating> createState() => _ChatingState();
}

class _ChatingState extends ConsumerState<Chating> {
  @override
  Widget build(BuildContext context) {
    final messageidnoti = ref.read(messageidnotifierprovider.notifier);
    final messageidnotiget = ref.read(messageidnotifierprovider);

    return Column(children: <Widget>[
      Expanded(
        child: StreamBuilder(
          stream: GetMessage.getMessages(widget.recipientid),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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

                  return Padding(
                    padding: EdgeInsets.only(
                      left: isMe
                          ? MediaQuery.of(context).size.width * 0.3
                          : MediaQuery.of(context).size.width * 0.03,
                      right: isMe
                          ? MediaQuery.of(context).size.width * 0.03
                          : MediaQuery.of(context).size.width * 0.3,
                    ),
                    child: Container(
                      child: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  messageidnoti.ontoggle(message.id);
                                  print(message.id);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background
                                            .withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(2, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12),
                                    color: isMe
                                        ? const Color.fromARGB(
                                            255, 211, 211, 211)
                                        : const Color.fromARGB(
                                            255, 48, 47, 47)),
                                child: Column(
                                  crossAxisAlignment: isMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message['message'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: isMe
                                            ? Colors.black
                                            : const Color.fromARGB(
                                                255, 255, 255, 255),
                                      ),
                                    ),
                                    messageidnotiget == message.id
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: isMe
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  timestamp != null
                                                      ? "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}"
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: isMe
                                                          ? Colors.black
                                                          : Colors.white),
                                                ),
                                                const SizedBox(width: 8),
                                                isMe
                                                    ? message['status'] ==
                                                            'seen'
                                                        ? SizedBox(
                                                            height: 14,
                                                            width: 14,
                                                            child: CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      widget
                                                                          .imageurl),
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            height: 14,
                                                            width: 14,
                                                            message['status'] ==
                                                                    'sent'
                                                                ? 'lib/icons/tick.png'
                                                                : 'lib/icons/tick.png')
                                                    : const SizedBox(
                                                        height: 0,
                                                      ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(
                                            height: 0,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
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
