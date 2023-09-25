import 'package:chat_app/screens/new_message.dart';
import 'package:chat_app/widget/messages_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text('Sign out'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
        child: Column(
          children: [Expanded(child: MessagesList()), NewMessage()],
        ),
      ),
    );
  }
}
