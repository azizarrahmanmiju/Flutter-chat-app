import 'package:flutter/material.dart';

class Singlelist extends StatelessWidget {
  final String image;
  final String name;
  final String lastmessage;
  final String laststatus;
  final type;

  const Singlelist({
    super.key,
    required this.image,
    required this.name,
    required this.lastmessage,
    required this.laststatus,
    required this.type,
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
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                // ignore: unnecessary_null_comparison
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    // const SizedBox(height: 0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastmessage, // Last message

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.6)),
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
