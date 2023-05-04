import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/screens/welcome_screen.dart';
import 'package:flash/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// for database in firebase
import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";

  const ChatScreen({super.key});
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String messageText = "";
  late User loggedInUser;

  @override
  void initState() {
    super.initState();
    loggedInUser = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          // Logout Button
          IconButton(
              icon: const Icon(Icons.close),
              // Logout Function
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (!mounted) return;
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //* List of messages
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _fireStore.collection('messages').snapshots(),
                builder: (context, collection) {
                  // Data
                  if (collection.hasData) {
                    final docs = collection.data!.docs;

                    return
                        // Docs is empty
                        docs.isEmpty
                            ? const Center(
                                child: Text(
                                  "There is no messages.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            :
                            // Has messages
                            ListView(
                                children: docs
                                    .map((doc) => Container(
                                          margin: const EdgeInsets.all(8.0),
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.green,
                                          child: Text(
                                            doc.data()["text"]!,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ))
                                    .toList(),
                              );
                  }
                  // Error
                  else if (collection.hasError) {
                    return const Center(
                      child: Text(
                        "Something went wrong!",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  // Loading
                  else {
                    return const LoadingWidget();
                  }
                },
              ),
            ),

            //* Send Area
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _fireStore.collection("messages").add({
                        "text": "Hello from app",
                        "sender": loggedInUser.email,
                        "date": FieldValue.serverTimestamp()
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
