import 'package:chat_app/riverpod/theme.dart';
import 'package:chat_app/shared_preference/store_modedata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Screen/Userlist.dart';
import 'package:chat_app/Screen/auth.dart';
import 'package:chat_app/Themes/themes.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebaseservice/firebase_options.dart';

final db = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  Future<void> loadTheme() async {
    bool? savedTheme = await getthem();
    setState(() {
      ref.watch(themeNotifierProvider.notifier).toggleTheme(savedTheme);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme == false ? darkTheme : lightTheme,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (cntx, snapshot) {
            if (snapshot.hasData) {
              return UserlistScreen();
            }
            return const AuthScreen();
          }),
    );
  }
}
