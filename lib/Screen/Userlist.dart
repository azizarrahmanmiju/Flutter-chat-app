import 'package:chat_app/Screen/chat_scree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

class Userlist extends StatefulWidget {
  const Userlist({super.key});

  @override
  State<Userlist> createState() => _UserlistState();
}

class _UserlistState extends State<Userlist> {
  List<Map<String, dynamic>> Userdata = [];
  List<Map<String, dynamic>> filteredUserdata = [];
  Map<String, dynamic> currentUserdata = {};

  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController searchController = TextEditingController();

  void userlist() async {
    await db.collection("Users").get().then(
      (querySnapshot) {
        print("Successfully completed");

        setState(() {
          Userdata.clear();
          for (var docSnapshot in querySnapshot.docs) {
            if (docSnapshot.data()['email'] != currentUser.email) {
              Userdata.add(docSnapshot.data());
            } else {
              currentUserdata = docSnapshot.data();
            }
          }
          filteredUserdata = List.from(Userdata); // Initialize filtered list
          print(Userdata);
        });
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void filterSearchResults(String query) {
    List<Map<String, dynamic>> dummyList = [];
    if (query.isNotEmpty) {
      dummyList = Userdata.where((user) {
        return user['name']
                ?.toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ??
            false;
      }).toList();

      setState(() {
        filteredUserdata = dummyList;
      });
    } else {
      setState(() {
        filteredUserdata = List.from(Userdata);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print(currentUser);
    userlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 245, 245),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: currentUserdata != null
              ? Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                      backgroundImage: NetworkImage(currentUserdata['image'] ??
                          "https://www.shutterstock.com/image-vector/user-icon-trendy-flat-style-600nw-1697898655.jpg"),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUserdata['name'] ?? "Congratulations ✨",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          currentUserdata['email'] ?? "account created!",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                )
              : Text("Congratulations"),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('You have been logged out'),
              ));
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Add the Search bar below AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    width: 1,
                  )),
              child: TextField(
                controller: searchController,
                onChanged: (value) => filterSearchResults(value),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search by name",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          const Text(
            "Users",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 5,
                right: 10,
              ),
              child: filteredUserdata.isEmpty
                  ? const Center(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 25),
                        Text('Loading...'),
                      ],
                    ))
                  : ListView.builder(
                      itemCount: filteredUserdata.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScree(
                                          recipienguid: filteredUserdata[index]
                                                  ['uid'] ??
                                              "",
                                          recipiename: filteredUserdata[index]
                                                  ['name'] ??
                                              "",
                                          recipieimage: filteredUserdata[index]
                                                  ['image'] ??
                                              "",
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: NetworkImage(
                                        filteredUserdata[index]['image'] ??
                                            'https://www.shutterstock.com/image-vector/user-icon-trendy-flat-style-600nw-1697898655.jpg',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          filteredUserdata[index]['name'] ??
                                              'No Name',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(filteredUserdata[index]['email'] ??
                                            'No Email'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
