import 'package:chat_app/widget/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUserId = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(child: Text('No messages here right now'));
          }
          if (chatSnapshots.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }

          final loadedMessages = chatSnapshots.data!.docs;

          //print('loaded msg = ${loadedMessages[0].data()['text']}');

          return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(bottom: 40),
              itemCount: loadedMessages.length,
              itemBuilder: (context, index) {
                final chatMessage = loadedMessages[index].data();
                final nextChatMeassge = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1].data()
                    : null;
                final currentMessageUserId = chatMessage['userId'];
                final nextMessageUserId =
                    nextChatMeassge != null ? nextChatMeassge['userId'] : null;

                final nextUserIsSame =
                    nextMessageUserId == currentMessageUserId;

                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessage['text'],
                      isMe: authenticatedUserId.uid == currentMessageUserId);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage['imageUrl'],
                      username: chatMessage['username'],
                      message: chatMessage['text'],
                      isMe: authenticatedUserId.uid == currentMessageUserId);
                }
              });
        });
  }
}
