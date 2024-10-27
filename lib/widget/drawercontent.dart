import 'package:chat_app/model/Userdata.dart';
import 'package:chat_app/service/getcurrentuserdata.dart';
import 'package:flutter/material.dart';

class Drawercontent extends StatelessWidget {
  const Drawercontent({
    super.key,
  });

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
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(currentuserdata.image!),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentuserdata.name!,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Text(
                        currentuserdata.email!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      )
                    ],
                  ),
                ),
              ),
              ListTile()
            ],
          );
        },
      ),
    );
  }
}
