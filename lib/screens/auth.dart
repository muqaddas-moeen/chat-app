import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/signup.dart';
import 'package:chat_app/widget/messages_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

var _firebase = FirebaseAuth.instance;

class authenticationScreen extends StatefulWidget {
  const authenticationScreen({super.key});

  @override
  State<authenticationScreen> createState() => _authenticationScreenState();
}

class _authenticationScreenState extends State<authenticationScreen> {
  final _form = GlobalKey<FormState>();
  var email;
  var password;
  var isAuthenticating = false;

  void validateData() async {
    final isValid = _form.currentState!.validate();
    print('isValid = ${isValid}');

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        isAuthenticating = true;
      });
      final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: email, password: password);

      // FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      //   if (user == null) {
      //     showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             title: const Text('Oh No!'),
      //             content: const Text(
      //                 'Seems that this account is not available. Please try to create an account first or login with another existed account. Thankyou!'),
      //             actions: [
      //               TextButton(
      //                 onPressed: () {
      //                   Navigator.of(context).pop();
      //                 },
      //                 child: const Text('OK'),
      //               ),
      //             ],
      //           );
      //         });
      //   } else {
      // });
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

    print(email);
    print(password);
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
              Image.asset(
                'assets/images/chat.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                  key: _form,
                  child: Column(
                    children: [
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
                            child: const Text('Login')),
                      const SizedBox(
                        height: 25,
                      ),
                      if (!isAuthenticating)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Not have an account? '),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                              },
                              child: const Text('create now!'),
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
