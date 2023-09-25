import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart"
    show FirebaseFirestore, Timestamp;
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final sendingMessage = messageController.text;

    if (sendingMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': sendingMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'imageUrl': userData.data()!['imageUrl']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            autocorrect: true,
            decoration: const InputDecoration(
              hintText: 'Send message',
              fillColor: Colors.deepPurple,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            enableSuggestions: true,
          ),
        ),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
      ],
    );
  }
}
