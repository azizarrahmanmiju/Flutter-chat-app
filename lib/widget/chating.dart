import 'package:chat_app/firebaseservice/getmessage.dart';
import 'package:chat_app/widget/showpopupmenu.dart';
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
  bool ispressed = false;

  // Create a map to store unique keys for each message
  final Map<String, GlobalKey> messageKeys = {};

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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text('No messages'),
              );
            }
            var messages = snapshot.data!.docs;

            return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot message = messages[index];
                  final messageId = message.id;

                  // Retrieve or create a unique GlobalKey for each message
                  messageKeys[messageId] ??= GlobalKey();

                  final isMe = message['senderId'] ==
                      FirebaseAuth.instance.currentUser!.uid;
                  final timestamp = message['timestamp'] != null
                      ? (message['timestamp'] as Timestamp).toDate()
                      : null;

                  return Padding(
                    padding: EdgeInsets.only(
                      left: isMe
                          ? MediaQuery.of(context).size.width * 0.3
                          : MediaQuery.of(context).size.width * 0.03,
                      right: isMe
                          ? MediaQuery.of(context).size.width * 0.03
                          : MediaQuery.of(context).size.width * 0.3,
                    ),
                    child: GestureDetector(
                        onLongPress: () {
                          setState(() {
                            ispressed = !ispressed;
                          });
                        },
                        child: GestureDetector(
                          key: messageKeys[messageId],
                          onLongPress: () {
                            final RenderBox box = messageKeys[messageId]!
                                .currentContext!
                                .findRenderObject() as RenderBox;
                            final Offset position =
                                box.localToGlobal(Offset.zero);

                            if (isMe)
                              showPopupMenu(context, position, messageId,
                                  message['fileType']);
                          },
                          child: Container(
                            child: Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: message['fileType'] == 'image'
                                            ? 1
                                            : 15,
                                        bottom: 2,
                                        right: message['fileType'] == 'image'
                                            ? 1
                                            : 5,
                                        top: 1),
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            offset: Offset(0, 0),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(12),
                                        color: isMe
                                            ? const Color.fromARGB(
                                                255, 250, 250, 250)
                                            : const Color.fromARGB(
                                                255, 48, 47, 47)),
                                    child: Column(
                                      crossAxisAlignment: isMe
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        message['fileType'] == 'image'
                                            ? Container(
                                                height: 170,
                                                width: 150,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Image.network(
                                                  message['image'],
                                                  fit: BoxFit.cover,
                                                  height: 150,
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                  right: 5,
                                                ),
                                                child: Text(
                                                  message['message'],
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: isMe
                                                        ? Colors.black
                                                        : const Color.fromARGB(
                                                            255, 250, 250, 250),
                                                  ),
                                                ),
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                            right: 5,
                                            bottom: 0,
                                          ),
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
                                                    fontSize: 12,
                                                    color: isMe
                                                        ? const Color.fromARGB(
                                                            186, 0, 0, 0)
                                                        : const Color.fromARGB(
                                                            255,
                                                            201,
                                                            200,
                                                            200)),
                                              ),
                                              const SizedBox(width: 8),
                                              isMe
                                                  ? message['status'] == 'seen'
                                                      ? SizedBox(
                                                          height: 14,
                                                          width: 14,
                                                          child: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(widget
                                                                    .imageurl),
                                                          ),
                                                        )
                                                      : Image.asset(
                                                          height: 14,
                                                          width: 14,
                                                          message['status'] ==
                                                                  'sent'
                                                              ? 'lib/icons/sent.png'
                                                              : 'lib/icons/tick.png')
                                                  : const SizedBox(height: 0),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ),
                        )),
                  );
                });
          },
        ),
      )
    ]);
  }
}
