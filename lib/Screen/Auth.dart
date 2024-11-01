import 'dart:io';
import 'dart:ui';

import 'package:chat_app/widget/Imagepicker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AuthScreen();
  }
}

class _AuthScreen extends State<AuthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  var _islogin = true;
  String? _enteredemail;
  String? _enteredpassword;
  String? _enteredname;

  var _isauthenticating = false;

  File? _Selectediamge;

  void Submit() async {
    final _isvalid = _formkey.currentState!.validate();
    if (!_isvalid) {
      return;
    } else if (_Selectediamge == null && !_islogin) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
        ),
      );
      return;
    } else {
      _formkey.currentState!.save();

      try {
        setState(() {
          _isauthenticating = true;
        });
        if (_islogin) {
          await _firebase.signInWithEmailAndPassword(
              email: _enteredemail!, password: _enteredpassword!);
        } else {
          final response = await _firebase.createUserWithEmailAndPassword(
              email: _enteredemail!, password: _enteredpassword!);

          final storageref = FirebaseStorage.instance
              .ref()
              .child("Users_images")
              .child(response.user!.uid);

          await storageref.putFile(_Selectediamge!);
          final imageurl = await storageref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('Users')
              .doc(response.user!.uid)
              .set({
            'email': _enteredemail,
            'name': _enteredname,
            'image': imageurl,
          });
        }
      } on FirebaseAuthException catch (error) {
        setState(() {
          _isauthenticating = false;
        });
        if (error.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('email allready Used')),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Authentication failed')),
          );
        }
      }
    }
  }

  ///submit================

  @override
  Widget build(BuildContext context) {
    final _colorpallet = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldkey,
      body: Stack(
        children: [
          Image.asset(
            'lib/icons/authback.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.2),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _islogin ? "SIGN IN" : "SING UP",
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      if (!_islogin)
                        PickImage(onpickimage: (image) {
                          _Selectediamge = image;
                        }),
                      const SizedBox(height: 20),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaY: 10.0,
                            sigmaX: 10.0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white38,
                                width: 1,
                              ),
                            ),
                            child: Form(
                              key: _formkey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!_islogin)
                                    TextFormField(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      cursorColor: _colorpallet.onBackground,
                                      onSaved: (newValue) {
                                        setState(() {
                                          _enteredname = newValue!;
                                        });
                                      },
                                      autocorrect: false,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return '';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person,
                                            color: Colors.white),
                                        label: Text("Enter User name",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  const SizedBox(height: 10),

                                  //==============
                                  TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.text,
                                    onSaved: (newValue) {
                                      setState(() {
                                        _enteredemail = newValue!;
                                      });
                                    },
                                    autocorrect: false,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty ||
                                          !value.contains("@")) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.mail, color: Colors.white),
                                      label: Text(
                                        "Enter Email Address",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    onSaved: (newValue) {
                                      setState(() {
                                        _enteredpassword = newValue!;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty ||
                                          value.length < 6) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    autofocus: false,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.6),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.password,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        "Enter Password",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),

                                  //========

                                  const SizedBox(height: 10),

                                  if (_isauthenticating)
                                    const CircularProgressIndicator(),
                                  if (!_isauthenticating)
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromARGB(
                                                    255, 255, 255, 255)),
                                      ),
                                      onPressed: Submit,
                                      child: Text(
                                        _islogin ? "SiGN IN" : "SIGN UP",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  if (!_isauthenticating)
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _islogin = !_islogin;
                                          });
                                        },
                                        child: Text(
                                          _islogin
                                              ? "Don't have an account? Sign up"
                                              : "Already have an",
                                          style: const TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 236, 154, 148),
                                              fontSize: 12),
                                        ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
