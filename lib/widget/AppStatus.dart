import 'package:flutter/material.dart';

class Appstatus extends StatelessWidget {
  const Appstatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Apps Not Up to Date.. Still  in Development',
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
