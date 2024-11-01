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
  const UserlistScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Userlist();
  }
}

class _Userlist extends State<UserlistScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late Stream<User?> authStateChanges;

  @override
  void initState() {
    authStateChanges = FirebaseAuth.instance.authStateChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authStateChanges,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // User is not logged in, show login screen or prompt
          return const Center(child: CircularProgressIndicator());
        }

        // User is logged in, fetch data
        return buildUserListScreen(snapshot.data!);
      },
    );
  }

  Widget buildUserListScreen(User user) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: StreamBuilder(
            stream: fetchcurrentuserdata(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('wait...');
              }
              if (snapshot.hasData) {
                final currentuserdat = snapshot.data!;
                return GestureDetector(
                  onTap: () => _scaffoldkey.currentState!.openDrawer(),
                  child: userappbar(
                    name: currentuserdat.name!,
                    image: currentuserdat.image!,
                  ),
                );
              }
              return const Icon(Icons.error);
            },
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: fetchcurrentuserdata(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('...');
              }
              if (snapshot.hasData) {
                final currentuserdat = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentuserdat.name!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      "welcome back to talkflow",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                  ],
                );
              }
              return const Text('...');
            },
          ),
        ),
      ),
      drawer: const Drawercontent(),
      body: Stack(
        children: [
          Image.asset('lib/icons/authback.jpg',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top: 15, right: 15),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image.asset(
                      //   'lib/icons/chatbuble.png',
                      //   height: 100,
                      //   width: 100,
                      // ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              "Talkflow".toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 25),
                            // Text(
                            //   "recent  conversations",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Theme.of(context)
                            //           .colorScheme
                            //           .onBackground),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
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

                            String lastMessage = 'click to quick  reply';
                            String status = 'sent';
                            String messagetype = 'text';

                            if (messageSnapshot.hasData &&
                                messageSnapshot.data!.docs.isNotEmpty) {
                              final snapshotdata =
                                  messageSnapshot.data!.docs.first;

                              lastMessage = snapshotdata['message'];
                              status = snapshotdata['status'];
                              messagetype = snapshotdata['fileType'];
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
                                type: messagetype,
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
        ],
      ),
    );
  }
}
