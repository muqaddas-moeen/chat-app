import 'dart:io';

import 'package:chat_app/screens/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart" show FirebaseFirestore;
import 'package:image_picker/image_picker.dart';

var _firebase = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  var email;
  var password;
  var username;
  var isAuthenticating = false;

  void validateData() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    if (imageSelected == null) {
      return;
    }

    _form.currentState!.save();
    try {
      setState(() {
        isAuthenticating = true;
      });
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: email, password: password);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userCredentials.user!.uid}.jpg');
      await storageRef.putFile(imageSelected!);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({'username': username, 'email': email, 'imageUrl': imageUrl});
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already in use')));
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed.')));
      setState(() {
        isAuthenticating = false;
      });
    }
  }

  File? imageSelected;

  void pickImage() async {
    final _pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 150, imageQuality: 50);

    if (_pickedImage == null) {
      return;
    }

    setState(() {
      imageSelected = File(_pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 40.0, right: 40, bottom: 40, top: 100),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                foregroundImage:
                    imageSelected != null ? FileImage(imageSelected!) : null,
              ),
              TextButton.icon(
                  onPressed: () {
                    pickImage();
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Add image')),
              const SizedBox(
                height: 40,
              ),
              Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Username'),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.trim().length < 4) {
                            return 'Please enter atleast 4 characters long name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        onSaved: (newValue) {
                          username = newValue;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Email'),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter valid email address';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        onSaved: (newValue) {
                          email = newValue;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Password'),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'Password should be of length 6';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          password = newValue;
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      if (isAuthenticating) const CircularProgressIndicator(),
                      if (!isAuthenticating)
                        ElevatedButton(
                            onPressed: () {
                              validateData();
                            },
                            child: const Text('Create Account')),
                      const SizedBox(
                        height: 25,
                      ),
                      if (!isAuthenticating)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? '),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const authenticationScreen()));
                              },
                              child: const Text('login now!'),
                            )
                          ],
                        )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
