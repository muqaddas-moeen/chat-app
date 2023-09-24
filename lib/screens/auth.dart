import 'package:flutter/material.dart';

class authenticationScreen extends StatefulWidget {
  const authenticationScreen({super.key});

  @override
  State<authenticationScreen> createState() => _authenticationScreenState();
}

class _authenticationScreenState extends State<authenticationScreen> {
  final _form = GlobalKey<FormState>();
  var email;
  var password;

  void validateData() {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      print(email);
      print(password);
    }
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
                      ElevatedButton(
                          onPressed: () {
                            validateData();
                          },
                          child: const Text('Login'))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}