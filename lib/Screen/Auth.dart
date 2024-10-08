import 'dart:io';

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
          final response = await _firebase.signInWithEmailAndPassword(
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
            SnackBar(content: Text('email allready Used')),
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
              ),
              const SizedBox(
                height: 30,
              ),
              if (!_islogin)
                PickImage(onpickimage: (image) {
                  setState(() {
                    _Selectediamge = image;
                  });
                }),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    if (!_islogin)
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: TextFormField(
                          cursorColor: Colors.black,
                          onSaved: (newValue) {
                            setState(() {
                              _enteredname = newValue!;
                            });
                          },
                          autocorrect: false,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Color.fromARGB(255, 228, 228, 228),
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                            label: const Text(
                              "Enter User name",
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: TextFormField(
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color.fromARGB(255, 228, 228, 228),
                          prefixIcon: Icon(Icons.person,
                              color: Theme.of(context).colorScheme.primary),
                          label: Text("Enter Email Address"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: TextFormField(
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
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.password,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          label: Text("Enter Password"),
                          filled: true,
                          fillColor: Color.fromARGB(255, 228, 228, 228),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_isauthenticating) CircularProgressIndicator(),
                    if (!_isauthenticating)
                      FilledButton(
                        onPressed: Submit,
                        // ignore: sort_child_properties_last
                        child: Text(_islogin ? "Log In" : "Sing Up"),
                        style: FilledButton.styleFrom(
                          fixedSize: const Size(double.maxFinite, 50),
                        ),
                      ),
                    if (!_isauthenticating)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _islogin = !_islogin;
                          });
                        },
                        child: Text(_islogin
                            ? "create An new Acount"
                            : "already have an account"),
                      )
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
