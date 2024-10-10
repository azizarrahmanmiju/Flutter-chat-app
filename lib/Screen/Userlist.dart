import 'package:chat_app/Screen/chat_scree.dart';
import 'package:chat_app/service/getdata.dart';
import 'package:chat_app/widget/singlelist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserlistScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Userlist();
  }
}

class _Userlist extends State<UserlistScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 235, 235),
        title: const Text('Messages'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              })
        ],
      ),
      body: StreamBuilder(
        stream:
            GetDataService.getdataStream(), // Use the stream instead of future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("No data available"),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("There was an error"),
            );
          }

          var userdata = snapshot.data;

          return ListView.builder(
            itemCount: userdata!.length,
            itemBuilder: (context, index) => InkWell(
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
              ),
            ),
          );
        },
      ),
    );
  }
}
