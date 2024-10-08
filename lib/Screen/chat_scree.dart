import 'package:chat_app/widget/no_massege.dart';
import 'package:flutter/material.dart';

class ChatScree extends StatefulWidget {
  const ChatScree(
      {required this.recipienguid,
      required this.recipiename,
      required this.recipieimage});

  final String recipienguid;
  final String recipiename;
  final String recipieimage;

  @override
  State<StatefulWidget> createState() {
    return _ChatScreen();
  }
}

class _ChatScreen extends State<ChatScree> {
  final _messagecontroller = TextEditingController();

  @override
  void dispose() {
    _messagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 207, 207),
        title: Row(
          children: [
            CircleAvatar(
                radius: 20,
                backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                backgroundImage: NetworkImage(widget.recipieimage)),
            const SizedBox(
              width: 20,
            ),
            Text(
              widget.recipiename,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06,
                color: const Color.fromARGB(255, 56, 56, 56),
              ),
            )
          ],
        ),
      ),
      body: Expanded(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 5, bottom: 10, top: 20),
          child: Column(
            children: [
              Expanded(
                child: NoMassege(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: const Color.fromARGB(255, 31, 31, 31),
                          width: 2,
                        )),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                          controller: _messagecontroller,
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: true,
                          cursorWidth: 2,
                          cursorColor: Colors.black,
                          enableSuggestions: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          )),
                    ),
                  ),
                  Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(0, 255, 255, 255),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          border: Border.all(
                            color: const Color.fromARGB(255, 31, 31, 31),
                            width: 2,
                          )),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.send,
                            color: Colors.black,
                          )))
                ],
              ),
            ],
          ),
        ),
      ), //appbar
    );
  }
}
