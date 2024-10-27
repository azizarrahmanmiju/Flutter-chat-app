import 'package:chat_app/model/Userdata.dart';
import 'package:chat_app/firebaseservice/getcurrentuserdata.dart';
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
  bool islightmode = true;

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
        stream: fetchcurrentuserdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          Userdata currentuserdata = snapshot.data as Userdata;
          return ListView(
            children: [
              Container(),
              const SizedBox(
                height: 35,
              ),
              Expanded(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(currentuserdata.image!),
                  ),
                  title: const Text("Profile"),
                  subtitle: Text(currentuserdata.name!),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text(
                  "Light mode",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(currentuserdata.theme!),
                trailing: CupertinoSwitch(
                    value: islightmode,
                    onChanged: (value) {
                      setState(() {
                        islightmode = value;
                      });
                    }),
              )
            ],
          );
        },
      ),
    );
  }
}
