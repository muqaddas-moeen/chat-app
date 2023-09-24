import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  AlertBox(
      {super.key,
      required this.title,
      required this.content,
      required this.buttonText});

  var title;
  var content;
  var buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20), child: Text(''));
  }
}
