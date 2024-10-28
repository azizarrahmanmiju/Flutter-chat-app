import 'package:chat_app/Screen/chat_scree.dart';
import 'package:chat_app/model/Userdata.dart';
import 'package:chat_app/firebaseservice/getcurrentuserdata.dart';
import 'package:chat_app/firebaseservice/getdata.dart';
import 'package:chat_app/firebaseservice/getmessage.dart';
import 'package:chat_app/widget/Userappbar.dart';
import 'package:chat_app/widget/drawercontent.dart';
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

  @override
  Widget build(BuildContext context) {
    Userdata currentuserdat;
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: Container(),
        title: StreamBuilder(
          stream: fetchcurrentuserdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('...');
            }
            currentuserdat = snapshot.data ??
                const Userdata(
                    id: '',
                    name: 'No account',
                    email: 'no email',
                    image: '',
                    theme: 'light');

            return GestureDetector(
              onTap: () => _scaffoldkey.currentState!.openDrawer(),
              child: userappbar(
                  name: currentuserdat.name!, image: currentuserdat.image!),
            );
          },
        ),
      ),
      drawer: const Drawercontent(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.8),
                  ),
                ),
                Text(
                  "Talkflow",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(height: 25),
                Text(
                  "recent  conversations",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
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
                          status = messageSnapshot.data!.docs
                              .first['status']; // Adjust based on your field
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
          ),
        ],
      ),
    );
  }
}
