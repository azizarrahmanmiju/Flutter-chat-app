import 'package:chat_app/Screen/Userlist.dart';
import 'package:chat_app/model/Userdata.dart';
import 'package:chat_app/firebaseservice/getcurrentuserdata.dart';
import 'package:chat_app/riverpod/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Drawercontent extends ConsumerStatefulWidget {
  const Drawercontent({
    super.key,
  });

  @override
  ConsumerState<Drawercontent> createState() => _DrawercontentState();
}

class _DrawercontentState extends ConsumerState<Drawercontent> {
  // @override
  // void initState() {
  //   super.initState();
  //}

  @override
  Widget build(BuildContext context) {
    final themetogleresponse = ref.read(themeNotifierProvider.notifier);
    bool islightmode = ref.watch(themeNotifierProvider);

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: StreamBuilder(
        stream: fetchcurrentuserdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Userdata currentuserdata = snapshot.data ??
              const Userdata(
                  id: '',
                  name: 'No account',
                  email: 'no email',
                  image: '',
                  theme: 'light');
          return Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Divider(),

                // const SizedBox(
                //   height: 35,
                // ),
                Expanded(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(currentuserdata.image!),
                    ),
                    title: const Text(
                      "Profile",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      currentuserdata.name!,
                      maxLines: 1,
                    ),
                  ),
                ),
                // const SizedBox(height: 10),

                ListTile(
                  title: const Text(
                    "Light mode",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: CupertinoSwitch(
                      value: islightmode,
                      onChanged: (value) {
                        setState(() {
                          themetogleresponse.toggleTheme(value);
                        });
                      }),
                ),

                currentUser != null
                    ? ElevatedButton.icon(
                        label: Text("Log out"),
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(
                                      'logging  out',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    content: Text(
                                      'Are you Sure to logging out?',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          FirebaseAuth.instance.signOut();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Yes!'),
                                      ),
                                    ],
                                  ));
                        },
                      )
                    : Text(
                        'Please log in',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}
