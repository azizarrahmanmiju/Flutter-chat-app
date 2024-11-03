import 'package:flutter/material.dart';

void showPopupMenu(context, position, message) async {
  final selected = await showMenu(
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
      const PopupMenuItem(
        value: 'delete',
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete'),
          ],
        ),
      ),
      // Add other options here if needed
    ],
    elevation: 8.0,
  );

  if (selected == 'delete') {
    // _deleteMessage(message);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message deleted form ${message}'),
      ),
    );
  }
}
