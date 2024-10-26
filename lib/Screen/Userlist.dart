import 'dart:ui';

import 'package:chat_app/Screen/chat_scree.dart';
import 'package:chat_app/model/Userdata.dart';
import 'package:chat_app/service/getcurrentuserdata.dart';
import 'package:chat_app/service/getdata.dart';
import 'package:chat_app/service/getmessage.dart';
import 'package:chat_app/widget/singlelist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final currentUser = FirebaseAuth.instance.currentUser;

class UserlistScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Userlist();
  }
}

class _Userlist extends State<UserlistScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final bool _isme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: StreamBuilder(
            stream: fetchcurrentuserdata(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }

              Userdata currentUserData = snapshot.data!;
              return Row(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(currentUserData.image!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUserData.name!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "welcome back to talkflow",
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  ),
                ],
              );
            }),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: GetDataService.getdataStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Center(child: Text("No data available")),
                );
              }
              if (snapshot.hasError) {
                print('has error');

                return const Center(
                  child: Center(child: Text("There was an error")),
                );
              }

              var userdata = snapshot.data;

              return ListView.builder(
                itemCount: userdata!.length,
                itemBuilder: (context, index) {
                  return StreamBuilder(
                    stream: getLastMessageStream(userdata[index].id!),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot> messageSnapshot) {
                      if (messageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      String lastMessage = '';
                      String status = 'sent';

                      if (messageSnapshot.hasData &&
                          messageSnapshot.data!.docs.isNotEmpty) {
                        lastMessage = messageSnapshot.data!.docs
                            .first['message']; // Adjust based on your field
                        status = messageSnapshot.data!.docs.first['status'] ??
                            ""; // Adjust based on your field
                      }

                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              recipientId: userdata[index].id!,
                              recipientName: userdata[index].name!,
                              recipientimage: userdata[index].image!,
                            ),
                          ),
                        ),
                        child: Singlelist(
                          image: userdata[index].image!,
                          name: userdata[index].name!,
                          lastmessage: lastMessage,
                          laststatus: status,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
