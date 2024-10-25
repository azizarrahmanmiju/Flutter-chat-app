import 'package:flutter/material.dart';

class Singlelist extends StatelessWidget {
  final String image;
  final String name;
  final String lastmessage;
  final String laststatus;

  const Singlelist({
    super.key,
    required this.image,
    required this.name,
    required this.lastmessage,
    required this.laststatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(137, 231, 231, 231),
                blurRadius: 5,
                spreadRadius: 3,
                offset: Offset(0, 5),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: image != null
                    ? NetworkImage(image)
                    : const AssetImage(
                        'lib/icons/profile.jpg'), // example for the user image
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name, // Username or title
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastmessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 5),
                        // laststatus == 'seen'
                        //     ? SizedBox(
                        //         height: 14,
                        //         width: 14,
                        //         child: CircleAvatar(
                        //           backgroundImage: NetworkImage(image),
                        //         ),
                        //       )
                        //     :  Image.asset(
                        //         height: 14,
                        //         width: 14,
                        //         laststatus == 'sent'
                        //             ? 'lib/icons/sent.png'
                        //             : 'lib/icons/tick.png'),
                      ],
                    ),
                  ],
                ),
              ),
              // Any other widgets like timestamps or message status
            ],
          ),
        ),
      ),
    );
  }
}
