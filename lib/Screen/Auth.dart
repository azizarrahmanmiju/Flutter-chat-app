import 'dart:io';

import 'package:chat_app/widget/Imagepicker.dart';
import 'package:chat_app/widget/drawercontent.dart';
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
    final _colorpallet = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldkey,
      drawer: Drawercontent(),
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              _scaffoldkey.currentState!.openDrawer();
            },
            child: Icon(Icons.menu)),
      ),
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
              if (_islogin)
                Image.asset(
                  'assets/images/logo.png',
                  height: 60,
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
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 2, // soften the shadow
                              spreadRadius: 0.2, //extend the shadow
                              color: Colors.grey,
                              blurStyle: BlurStyle.normal,
                            )
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: TextFormField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          cursorColor: _colorpallet.onBackground,
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person,
                                color: _colorpallet.onBackground),
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
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 2, // soften the shadow
                            spreadRadius: 0.2, //extend the shadow
                            color: Colors.grey,
                            blurStyle: BlurStyle.normal,
                          )
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: TextFormField(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person,
                              color: Theme.of(context).colorScheme.primary),
                          label: const Text("Enter Email Address"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 2, // soften the shadow
                            spreadRadius: 0.2, //extend the shadow
                            color: Colors.grey,
                            blurStyle: BlurStyle.normal,
                          )
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: TextFormField(
                        style: TextStyle(color: _colorpallet.primary),
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
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.password,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          label: Text("Enter Password"),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0),
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
