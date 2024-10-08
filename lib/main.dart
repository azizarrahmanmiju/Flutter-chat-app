import 'package:chat_app/Screen/Userlist.dart';
import 'package:chat_app/Screen/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 243, 33, 33),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (cntx, snapshot) {
            if (snapshot.hasData) {
              return const Userlist();
            }
            return AuthScreen();
          }),
    );
  }
}
