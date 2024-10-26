import 'package:chat_app/Screen/chat_scree.dart';
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
  final bool _isme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Icon(Icons.abc),
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage(
                "lib/icons/profile.jpg",
              ), // example for the user image
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Azizar rahman',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Text(
                  "Wellcome back to Talkflow",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: GetDataService.getdataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting');
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
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> messageSnapshot) {
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
    );
  }
}
