import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class SendWidget extends StatefulWidget {
  const SendWidget({required this.userEmail});

  final String userEmail;

  @override
  State<SendWidget> createState() => _SendWidgetState();
}

class _SendWidgetState extends State<SendWidget> {
  final _fireStore = FirebaseFirestore.instance;
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kMessageContainerDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: textEditingController,
              decoration: kMessageTextFieldDecoration,
            ),
          ),
          InkWell(
            child: TextButton(
              onPressed: () {
                if (textEditingController.text.trim().isNotEmpty) {
                  // Send msg

                  _fireStore.collection("messages").add(
                      // Message Map
                      {
                        "text": textEditingController.text,
                        "sender": widget.userEmail,
                        "date": FieldValue.serverTimestamp(),
                      });
                  // Clear text
                  textEditingController.clear();
                }

                // ()
              },
              child: const Text(
                'Send',
                style: kSendButtonTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
