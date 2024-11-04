import 'package:chat_app/firebaseservice/Updatemessage.dart';
import 'package:chat_app/firebaseservice/deletemessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showPopupMenu(context, position, messageId, type) async {
  final colorpallet = Theme.of(context).colorScheme;
  final textcontroller = TextEditingController();

  final selected = await showMenu(
    color: colorpallet.surface.withOpacity(0.8),
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy - 50, // Adjusts the vertical position above the message
      position.dx - 500,
      position.dy,
      // double.infinity,
      // double.infinity,
      // double.infinity,
      // double.infinity,
    ),
    items: [
      if (type == 'text')
        PopupMenuItem(
          value: 'Edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: colorpallet.onSurface),
              const SizedBox(width: 8),
              const Text('Edit'),
            ],
          ),
        ),
      PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Icon(Icons.delete, color: colorpallet.onSurface),
            const SizedBox(width: 8),
            const Text('Delete'),
          ],
        ),
      ),
    ],
    elevation: 0.6,
  );

  if (selected == 'delete') {
    deletmessage(messageId);
    // ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message deleted form ${messageId}'),
      ),
    );
  } else if (selected == 'Edit') {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Message',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textcontroller,
              onChanged: (value) {
                var text = value;
              },
              decoration: const InputDecoration(label: Text("new message")),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("cencel"),
          ),
          TextButton(
            onPressed: () {
              Updatemessage(
                messageId,
                textcontroller.text,
              );
              Navigator.pop(context);
            },
            child: const Text("chenge"),
          )
        ],
      ),
    );
  }
}
